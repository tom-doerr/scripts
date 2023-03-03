#!/usr/bin/env python3


import requests

# desktopBaseURL = "https://example.com"
# const desktopBaseURL = "http://abcd.airdns.org:12351";
desktopBaseURL = "http://abcd.airdns.org:12351"

def getHHMMLeft(tag):
    url = desktopBaseURL + '/hh_mm_left'
    # url = dbURLBase + 'hh_mm_left'
    params = {'tag': tag}
    response = requests.get(url, params=params)
    return response.text

    if response.status_code == 200:
        return response.text
    else:
        return None


TAGS = ['obj', 'obj2', 'obj3']

# response = getHHMMLeft('obj')
# print("response:", response)
for tag in TAGS:
    response = getHHMMLeft(tag)
    # print(response)
    print(f'{tag}: {response}')
