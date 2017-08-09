from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.common.keys import Keys
import time
import random
import csv
email=""
pwd=""
with open('acc.csv') as csvin:
	readfile=csv.reader(csvin, delimiter=";")
	i=0
	for row in readfile:
		print("["+str(i)+"]["+'|'.join(row)+"]")
		i=i+1
	print("Select Account: ")
with open('acc.csv') as csvin:
	readfile=csv.reader(csvin, delimiter=";")
	x=int(raw_input())
	i=0
	for row in readfile:
		if(x==i):
			email=row[0]
			pwd=row[1]
			break	
		i=i+1
option = webdriver.ChromeOptions()
option.add_argument("--no-sandbox")

# create new instance of chrome in incognito mode
browser = webdriver.Chrome(executable_path='/chromedriver', chrome_options=option)

# go to website of interest
browser.get("https://www.skillshare.com")
browser.execute_script("var elems = document.getElementsByClassName('btn small transparent initialized');for(var i= 0;i<elems.length;i++){elems[i].click();}")
browser.find_element_by_name('LoginForm[email]').send_keys(email)
browser.find_element_by_name('LoginForm[password]').send_keys(pwd)
print("enter any letter after completing captcha: ")
x=raw_input() # complete captcha then enter any string to continue the script
browser.execute_script("var elems = document.getElementsByClassName('btn large full-width primary btn-login-submit');for(var i= 0;i<elems.length;i++){elems[i].click();}")
try:	
	elem=browser.find_elements_by_xpath("//a[@class='btn extra-small bordered']")
	browser.get("http://skl.sh/2uU2sPf")
	browser.find_element_by_class_name('video-player-module').click()
	browser.execute_script("var elems = document.getElementsByClassName('playback-speed-popover popover dark');for(var i= 0;i<elems.length;i++){elems[i].click();}")
	browser.execute_script("window.open();")
	browser.execute_script("window.open();")
	browser.execute_script("window.open();")
	hnd=browser.window_handles
	browser.switch_to.window(hnd[1])
	browser.get(site1)
	browser.find_element_by_class_name('video-player-module').click()
	browser.execute_script("var elems = document.getElementsByClassName('playback-speed-popover popover dark');for(var i= 0;i<elems.length;i++){elems[i].click();}")
	browser.switch_to.window(hnd[2])
	browser.get(site2)
	browser.find_element_by_class_name('video-player-module').click()
	browser.execute_script("var elems = document.getElementsByClassName('playback-speed-popover popover dark');for(var i= 0;i<elems.length;i++){elems[i].click();}")
	browser.switch_to.window(hnd[3])
	browser.get(site3)
	browser.find_element_by_class_name('video-player-module').click()
	browser.execute_script("var elems = document.getElementsByClassName('playback-speed-popover popover dark');for(var i= 0;i<elems.length;i++){elems[i].click();}")
	
except selenium.common.exceptions.WebDriverException:
	time.sleep(30)
	y=random.randint(1,4)
	a=list()
	i=0
	while(i<y):
		x=random.randint(0,3)
		if (x in a == False):
			a.append(x)
			browser.execute_script("var elems = document.getElementsByClassName('default-tag select-box');elems["+str(x)+"].click();")
			i=i+1
	
	no=len(browser.find_elements_by_class_name('select-box'))
	try:
		a=list()
		i=0
		while(i<3):
			x=random.randint(0,no)
			if(x in a == False):
				a.append(x)
				browser.execute_script("var elems = document.getElementsByClassName('select-box');elems["+str(x)+"].click();")
				i=i+1
	except selenium.common.exceptions.WebDriverException:
		print ("Exception handled!!")
	browser.execute_script("var elems = document.getElementsByClassName('btn small primary right btn-continue');for(var i= 0;i<elems.length;i++){elems[i].click();}")
	time.sleep(10)
	elem=browser.find_elements_by_xpath("//a[@class='class-preview preview-overlay wishlist-preview maintain-image-ratio']")
	a=list()
	i=0
	while(i<3):
		x=random.randint(0,5)
		if(x in a == False):
			a.append(x)
			elem[x].click()
			i=i+1
	browser.execute_script("var elems = document.getElementsByClassName('btn small primary right btn-continue');for(var i= 0;i<elems.length;i++){elems[i].click();}")
	time.sleep(10)
	browser.execute_script("var elems = document.getElementsByClassName('btn small bordered right btn-continue');for(var i= 0;i<elems.length;i++){elems[i].click();}")
	browser.get("http://skl.sh/2uU2sPf")
	browser.find_element_by_class_name('video-player-module').click()
	browser.execute_script("var elems = document.getElementsByClassName('playback-speed-popover popover dark');for(var i= 0;i<elems.length;i++){elems[i].click();}")
	browser.execute_script("window.open();")
	browser.execute_script("window.open();")
	browser.execute_script("window.open();")
	hnd=browser.window_handles
	browser.switch_to.window(hnd[1])
	browser.get(site1)
	browser.find_element_by_class_name('video-player-module').click()
	browser.execute_script("var elems = document.getElementsByClassName('playback-speed-popover popover dark');for(var i= 0;i<elems.length;i++){elems[i].click();}")
	browser.switch_to.window(hnd[2])
	browser.get(site2)
	browser.find_element_by_class_name('video-player-module').click()
	browser.execute_script("var elems = document.getElementsByClassName('playback-speed-popover popover dark');for(var i= 0;i<elems.length;i++){elems[i].click();}")
	browser.switch_to.window(hnd[3])
	browser.get(site3)
	browser.find_element_by_class_name('video-player-module').click()
	browser.execute_script("var elems = document.getElementsByClassName('playback-speed-popover popover dark');for(var i= 0;i<elems.length;i++){elems[i].click();}")
