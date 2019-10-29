#!/usr/bin/env python3
import os
import re 
import datetime

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

due_goals_hm = []
for goal in due_goals:
    hm_time = [goal[0]]
    for hour_time_index in range(1, 4):
        time_seconds = int(goal[hour_time_index] * 3600)
        if time_seconds < 0:
            time_seconds *= -1
            sign = '-'
        else:
            sign = ''

        # source: https://stackoverflow.com/questions/775049/how-do-i-convert-seconds-to-hours-minutes-and-second://stackoverflow.com/questions/775049/how-do-i-convert-seconds-to-hours-minutes-and-seconds  
        m, s = divmod(time_seconds, 60)
        h, m = divmod(m, 60)
        hm_time.append(sign + f'{h:d}:{m:02d}')
    due_goals_hm.append(hm_time)



print('\n\n\n')
for e in due_goals_hm:
    print('{}    {}  {}  {}'.format(*e))

    
