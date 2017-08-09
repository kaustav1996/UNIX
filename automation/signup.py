from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.common.keys import Keys
import time
import random
import sys
while True:
	sys.stdout.write("=")
    	sys.stdout.flush()
	time.sleep(1)
option = webdriver.ChromeOptions()
option.add_argument("--no-sandbox")

# create new instance of chrome in incognito mode
browser = webdriver.Chrome(executable_path='/chromedriver', chrome_options=option)
browser.get("https://www.google.com")
browser.execute_script("window.open();")
browser.execute_script("window.open();")
browser.execute_script("window.open();")
hnd=browser.window_handles
browser.switch_to.window(hnd[1])
browser.get("https://www.google.com")
browser.switch_to.window(hnd[2])
browser.get("https://www.google.com")
browser.switch_to.window(hnd[3])
browser.get("https://www.google.com")
