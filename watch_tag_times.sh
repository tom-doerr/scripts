#!/bin/bash

watch -n 1 --no-title eval '
echo -n "obj:   " && timew su $(date --date="5 hours ago" +%Y-%m-%d)T05:00:00 - tomorrow obj   | tail -2 | head -1 | { read first rest; printf "%-10s\n" "$first"; }
echo -n "obj2:  " && timew su $(date --date="5 hours ago" +%Y-%m-%d)T05:00:00 - tomorrow obj2  | tail -2 | head -1 | { read first rest; printf "%-10s\n" "$first"; }
echo -n "obj3:  " && timew su $(date --date="5 hours ago" +%Y-%m-%d)T05:00:00 - tomorrow obj3  | tail -2 | head -1 | { read first rest; printf "%-10s\n" "$first"; }
echo -n "prof:  " && timew su $(date --date="5 hours ago" +%Y-%m-%d)T05:00:00 - tomorrow prof  | tail -2 | head -1 | { read first rest; printf "%-10s\n" "$first"; }
echo -n "ai:    " && timew su $(date --date="5 hours ago" +%Y-%m-%d)T05:00:00 - tomorrow ai    | tail -2 | head -1 | { read first rest; printf "%-10s\n" "$first"; }
echo -n "ai3:   " && timew su $(date --date="5 hours ago" +%Y-%m-%d)T05:00:00 - tomorrow ai3   | tail -2 | head -1 | { read first rest; printf "%-10s\n" "$first"; }
'
