#!/bin/bash
watch -n 1 --no-title eval 'echo "   "; timew su $(date --date "5 hours ago" +%Y-%m-%d)T05:00:00 - tomorrow prof | tail -2 | head -1 | { read first rest; echo $first; }'
