#!/usr/bin/env python3
import os
import re 

# source: https://stackoverflow.com/questions/10742296/python-time-conversion-hms-to-seconds
def hms_to_seconds(t):
    h, m, s = [int(i) for i in t.split(':')]
    return 3600*h + 60*m + s

bms_out = os.popen('zsh -c "source ~/.zshrc; bms"').read()
due_goals = []
for e in bms_out.split('\n'):
    m = re.search(r'/(.*?) .* \+(.*?) in .* hours', e)
    if m:
        due_goals.append([m.group(1), float(m.group(2))])
        tw_su_out = os.popen('zsh -c "source ~/.zshrc &> /dev/null; tsf ' + due_goals[-1][0] + '"').read()
        tw_su_out_time = tw_su_out.split('\n')[-2]
        if tw_su_out_time != 'No':
            seconds_done  = hms_to_seconds(tw_su_out_time)
        else:
            seconds_done = 0
        due_goals[-1].append(seconds_done / 3600)
        due_goals[-1].append(due_goals[-1][-1] - due_goals[-1][-2])

print('\n\n\n')
for e in due_goals:
    print('{}    {:3.2f}  {:3.2f}  {:3.2f}'.format(*e))

    
