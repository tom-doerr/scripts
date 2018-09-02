#!/usr/bin/env python3

import subprocess
PROCESS = subprocess.Popen('task _projects'.split(), stdout=subprocess.PIPE)
OUTPUT, ERROR = PROCESS.communicate()
projects_list = set()
for s in OUTPUT.decode('UTF-8').split('\n'):
    s = s.replace('\n', '')
    projects_list.add(s)


with open('/home/tom/Nextcloud/documents/gtd/projects', 'r') as f:
    content = f.readlines()
    
for s in content:
    s = s.replace('\n', '')
    projects_list.add(s)

print(projects_list)


with open('/home/tom/Nextcloud/documents/gtd/projects', 'w') as f:
    for e in sorted(list(projects_list)):
        f.write(e + '\n')
