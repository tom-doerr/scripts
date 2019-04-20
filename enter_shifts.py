#!/usr/bin/env python3

from selenium import webdriver
from time import sleep


options = webdriver.ChromeOptions() 
options.add_argument("user-data-dir=./Default")
browser = webdriver.Chrome(chrome_options=options)
browser.implicitly_wait(5)

browser.get('https://dienstplan.srv.lrz.de/mydata/ResourceCalendar')
for e in browser.find_elements_by_class_name('pull-right'):
    if e.text == 'Jetzt anmelden':
        e.click()

browser.find_element_by_class_name('glyphicon-chevron-right').click()


schichten_array = input('Kuerzel der Schichten eingeben (durch Leerzeichen getrennt): ').split(' ')
ziel_schichten_buttons = []
for e in browser.find_elements_by_class_name('t-calendar-slot'):
    print(e.text)
    if e.text in schichten_array:
        ziel_schichten_buttons.append(e)

number_matching_shifts = len(ziel_schichten_buttons)
print(str(number_matching_shifts) + ' passende Schichten gefunden.')


for i in range(number_matching_shifts):
    for e2 in browser.find_elements_by_class_name('t-calendar-slot'):
        print(e.text)
        if e2.text in schichten_array:
            ziel_schichten_buttons.append(e2)
    e = ziel_schichten_buttons[i]
    try:
        print(e.text)
        breakpoint()
        e.click()
        browser.find_element_by_class_name('tp-action-item').click()
        sleep(1)
        for b in browser.find_elements_by_class_name('btn-primary'):
            if b.text == 'Für diesen Dienst melden':
                b.click()
                browser.find_element_by_id('bot2-Msg1').click()
                sleep(2)
    except Exception as e:
        print(e)

