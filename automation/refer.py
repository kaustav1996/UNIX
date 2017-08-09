from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.common.keys import Keys
import time
import random
import csv
import sys
import os
import fcntl
def spsleep(maximum,minimum,message):
	x=random.randint(minimum,maximum)
	fl = fcntl.fcntl(sys.stdin.fileno(), fcntl.F_GETFL)
	fcntl.fcntl(sys.stdin.fileno(), fcntl.F_SETFL, fl | os.O_NONBLOCK)
	i=0
	print(message)
	while i<x:
		sys.stdout.write("=")
    		sys.stdout.flush()
    		try:
        		stdin = sys.stdin.read()
        		if "\n" in stdin or "\r" in stdin:
            			break
    		except IOError:
        		pass
    		time.sleep(1)
		i=i+1
fname=""
lname=""
email=""
pwd=""
site1=""
site2=""
site3=""
with open('accounts.csv') as csvin:
	readfile=csv.reader(csvin, delimiter=";")
	i=0
	for row in readfile:
		print("["+str(i)+"]["+'|'.join(row)+"]")
		i=i+1
	print("Select Account: ")
with open('accounts.csv') as csvin:
	readfile=csv.reader(csvin, delimiter=";")
	x=int(raw_input())
	i=0
	for row in readfile:
		if(x==i):
			fname=row[0]
			lname=row[1]
			email=row[2]
			pwd=row[3]
			site1=row[4]
			site2=row[5]
			site3=row[6]
			break	
		i=i+1
ccno=""
ccmonth=""
cvc=""
cctear=""
with open('credit_card.csv') as csvin:
	readfile=csv.reader(csvin, delimiter=";")
	i=0
	for row in readfile:
		print("["+str(i)+"]["+'|'.join(row)+"]")
		i=i+1
	print("Select Credit Card: ")
with open('credit_card.csv') as csvin:
	readfile=csv.reader(csvin, delimiter=";")
	x=int(raw_input())
	i=0
	for row in readfile:
		if(x==i):
			ccno=row[0]
			ccmonth=row[1]
			ccyear=row[2]
			cvc=row[3]
			break
		i=i+1
option = webdriver.ChromeOptions()
option.add_argument("--no-sandbox")

# create new instance of chrome in incognito mode
browser = webdriver.Chrome(executable_path='/chromedriver', chrome_options=option)

# go to website of interest
browser.get("http://skl.sh/2uU2sPf")
browser.execute_script("var elems = document.getElementsByClassName('banner-content initialized');for(var i= 0;i<elems.length;i++){elems[i].click();}")
inputelement=browser.find_element_by_class_name("email-prompt")
inputelement.click()	
inputelement=browser.find_element_by_class_name("signup-form-firstName")
inputelement.send_keys(fname)
inputelement=browser.find_element_by_class_name("signup-form-lastName")
inputelement.send_keys(lname)
inputelement=browser.find_element_by_class_name("signup-form-email")
inputelement.send_keys(email)
inputelement=browser.find_element_by_class_name("signup-form-password")
inputelement.send_keys(pwd)
print("enter any letter after completing captcha: ")
x=raw_input() # complete captcha then enter any string to continue the script
browser.execute_script("var elems = document.getElementsByClassName('btn large primary full-width btn-signup-submit');for(var i= 0;i<elems.length;i++){elems[i].click();}")
spsleep(15,10,"Signing in.. (enter any key to end sleep manually)") # as the sign up page also contains a butti=on of the class name 'btn bordered small' , sleep for 10 secs and then execute the next statement
browser.find_element_by_id("cc-number-input").send_keys(ccno)
browser.find_element_by_id("cc-expiration-month-input").click()
browser.find_element_by_xpath("//select[@id='cc-expiration-month-input']/option[@value='"+ccmonth+"']").click()
browser.find_element_by_id("cc-cvc-input").send_keys(cvc)
browser.find_element_by_id("cc-expiration-year-input").click()
browser.find_element_by_xpath("//select[@id='cc-expiration-year-input']/option[@value='"+ccyear+"']").click()
browser.find_element_by_xpath("//select[@id='checkout-survey-source']/option[@value='teacher']").click()
browser.execute_script("var elems = document.getElementsByClassName('btn large primary submit full-width');for(var i= 0;i<elems.length;i++){elems[i].click();}")
spsleep(30,20,"Processing Credit Card.. (enter any key to end sleep manually)")
y=random.randint(1,4)
a=list()
i=0
while(i<y):
	x=random.randint(0,3)
	if (x not in a):
		a.append(x)
		browser.execute_script("var elems = document.getElementsByClassName('default-tag select-box');elems["+str(x)+"].click();")
		i=i+1
	
no=len(browser.find_elements_by_class_name('select-box'))
try:
	a=list()
	i=0
	while(i<3):
		x=random.randint(0,no)
		if(x not in a):
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
	if(x not in a):
		a.append(x)
		elem[x].click()
		i=i+1
browser.execute_script("var elems = document.getElementsByClassName('btn small primary right btn-continue');for(var i= 0;i<elems.length;i++){elems[i].click();}")
spsleep(15,10,"Adding Classes.. (enter any key to end sleep manually)")
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
