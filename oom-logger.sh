#!/bin/bash
# Log system metrics for OOM debugging
LOG="$HOME/.local/log/oom-debug.log"
mkdir -p "$HOME/.local/log"
TS=$(date '+%Y-%m-%d %H:%M:%S')

# Memory info (in MB)
eval $(awk '/MemTotal/{t=$2}/MemAvailable/{a=$2}/Dirty/{d=$2}/^AnonPages/{ap=$2}/AnonHugePages/{ah=$2}/Shmem:/{sh=$2}
END{printf "total=%.0f avail=%.0f dirty=%.1f anon=%.0f anonhuge=%.1f shmem=%.1f",t/1048576,a/1048576,d/1048576,ap/1048576,ah/1048576,sh/1048576}' /proc/meminfo)
mem_pct=$((100 - avail * 100 / total))

# Swap info
read -r stotal sused <<< $(awk '/SwapTotal/{t=$2}/SwapFree/{f=$2}END{print t,t-f}' /proc/meminfo)
swap_pct=$([[ $stotal -gt 0 ]] && echo $((sused * 100 / stotal)) || echo 0)
swap_gb=$((sused / 1048576))

# PSI memory pressure (avg10)
psi=$(awk -F= '/some/{gsub(/ .*/,"",$2); print $2}' /proc/pressure/memory 2>/dev/null)

# Zram compression ratio
zram=$(zramctl --raw --noheadings -o DATA,COMPR /dev/zram0 2>/dev/null | awk '{if($2>0)printf "%.1fx",$1/$2}')

gpu=$(nvidia-smi --query-gpu=utilization.gpu,power.draw --format=csv,noheader,nounits 2>/dev/null | tr -d ' ')
top5=$(ps -eo comm,rss --sort=-rss | head -6 | tail -5 | awk '{printf "%s(%.1fG) ",$1,$2/1048576}')

echo "$TS MEM:${mem_pct}%/${avail}G SWAP:${swap_pct}%/${swap_gb}G PSI:${psi} ZRAM:${zram} GPU:${gpu} ANON:${anon}G HUGE:${anonhuge}G SHMEM:${shmem}G DIRTY:${dirty}G TOP:$top5" >> "$LOG"
