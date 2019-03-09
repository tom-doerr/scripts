#!/usr/bin/env python3

import subprocess
import re
import sys
from bashplotlib.histogram import plot_hist

try:
    tracking_label=sys.argv[1:]
except:
    tracking_label=list()

result = subprocess.run(['timew', 'su', '2018-01-01', '-', 'tomorrow']+tracking_label, stdout=subprocess.PIPE)

durations = list()
for e in str(result.stdout).split('\\n'):
    print(e)
    m = re.search(r"(?<=..:..:..)..:..:..", e)
    if m != None:
        durations += [m.group(0)]


print('\n\n' + str(durations))
duration_minutes = [int(e.split(':')[0])*60+int(e.split(':')[1]) for e in durations]
print(duration_minutes)

#print(subprocess.run(['bashplotlib']+duration_minutes))
plot_hist(duration_minutes, bincount=100, xlab=True)

