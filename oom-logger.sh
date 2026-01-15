#!/bin/bash
# Log system metrics for OOM debugging
LOG="$HOME/.local/log/oom-debug.log"
mkdir -p "$HOME/.local/log"
TS=$(date '+%Y-%m-%d %H:%M:%S')

# Memory info
read -r total avail <<< $(awk '/MemTotal/{t=$2}/MemAvailable/{a=$2}END{print t,a}' /proc/meminfo)
mem_pct=$((100 - avail * 100 / total))

# Swap info
read -r stotal sused <<< $(awk '/SwapTotal/{t=$2}/SwapFree/{f=$2}END{print t,t-f}' /proc/meminfo)
swap_pct=$([[ $stotal -gt 0 ]] && echo $((sused * 100 / stotal)) || echo 0)
gpu=$(nvidia-smi --query-gpu=utilization.gpu,power.draw --format=csv,noheader,nounits 2>/dev/null | tr -d ' ')
top5=$(ps -eo comm,%mem --sort=-%mem | head -6 | tail -5 | awk '{printf "%s(%s%%) ",$1,$2}')

echo "$TS MEM:${mem_pct}% SWAP:${swap_pct}% GPU:${gpu} TOP:$top5" >> "$LOG"
