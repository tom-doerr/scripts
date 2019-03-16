#!/usr/bin/env python3

import subprocess
import re
import sys
from bashplotlib.histogram import plot_hist


def plot_hist_tw(tracking_label):
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
    plot_hist(duration_minutes, bincount=100, xlab=False)

    duration_min = min(duration_minutes)
    duration_max = max(duration_minutes)
    bin_number = duration_minutes[-1] /((duration_max - duration_min) / 100)
    print('     ' + ' ' * int(bin_number) + '\033[31;1;4m#\033[0m')


if __name__ == '__main__':
    try:
        tracking_label=sys.argv[1:]
    except:
        tracking_label=list()

    plot_hist_tw(tracking_label)

