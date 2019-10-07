#!/usr/bin/env python3

import json
import sys
from pathlib import Path

with open(str(Path.home()) + '/.task/hooks/tags.config', 'r') as tag_config_file:
    TAG_CONFIG = json.load(tag_config_file)

new = []
for tag1 in sys.argv[1:]:
    if tag1 in TAG_CONFIG:
        tags_to_add = TAG_CONFIG[tag1]
        if type(tags_to_add) == str:
            new.append(tags_to_add)
        elif type(tags_to_add) == list:
            for tag in tags_to_add:
                new.append(tag)
        else:
            raise Exception('Tag type is not of type str or list, but of type ' + str(type(tags_to_add)))

print(' '.join(new))
