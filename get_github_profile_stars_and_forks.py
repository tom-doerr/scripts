#!/usr/bin/env python3

'''
Get a number from a website.
The number is inside a link element.

Example:
<a href="/tom-doerr/zsh_codex/stargazers" class="pinned-item-meta Link--muted ">
                <svg aria-label="stars" role="img" height="16" viewBox="0 0 16 16" version="1.1" width="16" data-view-component="true" class="octicon octicon-star">
    <path fill-rule="evenodd" d="M8 .25a.75.75 0 01.673.418l1.882 3.815 4.21.612a.75.75 0 01.416 1.279l-3.046 2.97.719 4.192a.75.75 0 01-1.088.791L8 12.347l-3.766 1.98a.75.75 0 01-1.088-.79l.72-4.194L.818 6.374a.75.75 0 01.416-1.28l4.21-.611L7.327.668A.75.75 0 018 .25zm0 2.445L6.615 5.5a.75.75 0 01-.564.41l-3.097.45 2.24 2.184a.75.75 0 01.216.664l-.528 3.084 2.769-1.456a.75.75 0 01.698 0l2.77 1.456-.53-3.084a.75.75 0 01.216-.664l2.24-2.183-3.096-.45a.75.75 0 01-.564-.41L8 2.694v.001z"></path>
</svg>
                332
              </a>

Output: 332


The url of the website from which to get the number is https://github.com/tom-doerr
'''

import requests
from bs4 import BeautifulSoup
import argparse
import datetime
import time


# Get repo name.
parser = argparse.ArgumentParser(description='Get number of stars for a github repo.')
parser.add_argument('repo', help='the github repo to check')
args = parser.parse_args()

url = "https://github.com/" + args.repo
# url = "https://github.com/tom-doerr"

r = requests.get(url)
soup = BeautifulSoup(r.text, 'html.parser')


# get all matching elements.
links = soup.find_all("a", {"class": "pinned-item-meta"})
# also get the correspondeng hrefs.
links = soup.find_all("a", {"class": "pinned-item-meta"}, href=True)
print('\n================================')
# print the current unix timestamp.
print('Timestamp: {:%Y-%b-%d %H:%M:%S}'.format(datetime.datetime.now()))
# Print the unix time in seconds.
print('Timestamp in seconds: {}'.format(time.time()))

# print all links
for link in links:
    print(link.text)
    print(link['href'])



