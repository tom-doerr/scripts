#!/usr/bin/env python3
import csv
import matplotlib
import matplotlib.pyplot as plt
from datetime import datetime

PATH_LOGFILE = '/home/tom/Nextcloud/documents/energy_log'


timestamps = []
energy_level = []
x_values = []

with open(PATH_LOGFILE) as f:
    reader = csv.reader(f)
    for row in reader:
        timestamps.append(row[0])
        energy_level.append(row[1])


fig, ax = plt.subplots()
x_values = [datetime.fromtimestamp(int(e)) for e in timestamps]

print(x_values)


ax.plot(x_values, energy_level, '.')

plt.show()


