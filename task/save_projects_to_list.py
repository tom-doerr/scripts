#!/usr/bin/env python3

import subprocess
import os.path
import json
import sys

#new = json.loads(sys.stdin.readline())
#print(json.dumps(new))
LOCK_PATH = '/tmp/save_projects_to_list.lock'

if os.path.isfile(LOCK_PATH):
    exit()

open(LOCK_PATH, 'w+')


PROCESS = subprocess.Popen('task _projects'.split(), stdout=subprocess.PIPE)
OUTPUT, ERROR = PROCESS.communicate()
projects_list = set()
for s in OUTPUT.decode('UTF-8').split('\n'):
    s = s.replace('\n', '')
    projects_list.add(s)


with open('/home/tom/Nextcloud/documents/gtd/projects', 'r') as f:
    CONTENT = f.readlines()

for s in CONTENT:
    s = s.replace('\n', '')
    projects_list.add(s)


with open('/home/tom/Nextcloud/documents/gtd/projects', 'w') as f:
    for e in sorted(list(projects_list)):
        f.write(e + '\n')

os.remove(LOCK_PATH)
