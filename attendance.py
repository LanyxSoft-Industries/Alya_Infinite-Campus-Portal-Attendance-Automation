import selenium, os, time, datetime, random, warnings, sys, argparse
from selenium import webdriver
from selenium.webdriver.firefox.options import Options
from selenium.webdriver.firefox.firefox_binary import FirefoxBinary

warnings.filterwarnings("ignore", category=DeprecationWarning) 
print("Timestamp: " + datetime.datetime.now().strftime("%D  %H:%M:%S"))

# Windows 10 - Firefox User Agent:
#	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:82.0) Gecko/20100101 Firefox/82.0
#
# iPadOS 14.1 - Safari User Agent:
#	Mozilla/5.0 (iPad; CPU OS 14_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1

CUSTOM_USER_AGENT = ""
URL = ""
ATTENDANCE_TAKEN = False
AUTOMATION_FAILED = False
USE_FAILSAFE_PERCAUTIONS = True
AD_PASSWORD = ""
AD_USERNAME = ""

arg_parser = argparse.ArgumentParser()
arg_parser.add_argument("-u", "--username", type=str, help="Specifies the user's username")
arg_parser.add_argument("-p", "--password", type=str, help="Specifies the user's password")
arg_parser.add_argument("-ua", "--user-agent", type=str, help="Specifies a custom user agent")
arg_parser.add_argument("-url", "--url", type=str, required=True, help="Specifies the Infinite campus URL")
arguments = arg_parser.parse_args()

if arguments.username is not None:
	AD_USERNAME = arguments.username
if arguments.password is not None:
	AD_PASSWORD = arguments.password
if arguments.user_agent is not None:
	if arguments.user_agent == "random":
		if random.randint(0, 1) == 0: CUSTOM_USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:82.0) Gecko/20100101 Firefox/82.0"
		else: CUSTOM_USER_AGENT = "Mozilla/5.0 (iPad; CPU OS 14_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1"
	else:
		CUSTOM_USER_AGENT = arguments.user_agent
if arguments.url is not None:
	URL = arguments.url

options = Options()
options.headless = True

profile = webdriver.FirefoxProfile()
profile.set_preference("general.useragent.override", CUSTOM_USER_AGENT)
binary = FirefoxBinary('/usr/lib/firefox/firefox')
driver = webdriver.Firefox(profile, options=options, firefox_binary=binary)
driver.maximize_window()
driver.get(URL)
assert "Campus Student" in driver.title
print("Successfully loaded Infinite Campus!")

if USE_FAILSAFE_PERCAUTIONS: time.sleep(60) # Until 'driver.implicitly_wait()' is figured out, we're going to use 'time.sleep()'
else: driver.implicitly_wait(60) # Implicitly wait until selenium can find the elements

user = driver.find_element_by_name("username")
passw = driver.find_element_by_name("password")
user.clear();passw.clear();
user.send_keys(AD_USERNAME)
passw.send_keys(AD_PASSWORD)
print(f"\nUser Agent: {CUSTOM_USER_AGENT} \nUsername: {user.get_attribute('value')} \nPassword: {passw.get_attribute('value')}\nUsing Failsafe Percautions: {USE_FAILSAFE_PERCAUTIONS}\n") # Get the entered value from the input element.
print("Uploading Credentials...")

for i in range(6):
	try:
		driver.find_element_by_css_selector("input.info.block").click()
		print("Successfully logged in!")
		break
	except selenium.common.exceptions.NoSuchElementException:
		print("[ERROR]: Attempting to resend credentials.")
		if USE_FAILSAFE_PERCAUTIONS: time.sleep(10)
		else: driver.implicitly_wait(10)

# Note: Below this comment, 'driver.implicitly_wait()' causes the
# program to fail. Use 'time.sleep()' instead.
for i in range(6):
	try:
		driver.switch_to.frame(driver.find_element_by_id("main-workspace"))
		print("Successsfully found 'main-workspace'")
		break
	except selenium.common.exceptions.NoSuchElementException:
		print("[ERROR]: Attempting to locate main-workspace frame.")
		if USE_FAILSAFE_PERCAUTIONS: time.sleep(10)
		else: driver.implicitly_wait(10)
	except selenium.common.exceptions.StaleElementReferenceException:
		print("[ERROR]: Element 'main-workspace' is stale, this may be caused by taking attendace earlier today.")
		AUTOMATION_FAILED = True
		break

for i in range(6):
	try:
		driver.find_element_by_css_selector("ul.list-none.p-0.m-0").click()
		print("Locking on attendance page...")
		break
	except selenium.common.exceptions.NoSuchElementException:
		print("[ERROR]: Attempting to find attendance page button.")
		if USE_FAILSAFE_PERCAUTIONS: time.sleep(10)
		else: driver.implicitly_wait(10)
	except selenium.common.exceptions.WebDriverException as e:
		print("[ERROR]: Attendance page button is non-existant, this may be caused by taking attendace earlier today.\n[ERROR DETAILS]:",e)
		AUTOMATION_FAILED = True
		break

for i in range(6):
	try:
		driver.find_element_by_tag_name("button").click()
		print("Attendance taken!")
		ATTENDANCE_TAKEN = True
		break
	except selenium.common.exceptions.NoSuchElementException:
		print("[ERROR]: Attempting to find attendance button.")
		if USE_FAILSAFE_PERCAUTIONS: time.sleep(10)
		else: driver.implicitly_wait(10)
	except selenium.common.exceptions.WebDriverException as e:
		print("[ERROR]: Attendance button is non-existant, this may be caused by taking attendace earlier today.\n[ERROR DETAILS]:",e)
		AUTOMATION_FAILED = True
		break

driver.quit()
print("Closing Firefox Session...Done!\n\n")
if AUTOMATION_FAILED:
	os.system(f'notify-send --app-name="LanyxSoft liOS" --urgency="normal" --icon="/home/kali/Environments/Icons/1920x1080/icon-failed.jpg" "School Attendance Automation Status" "Automation Complete with completion status: {ATTENDANCE_TAKEN}"')
else:
	os.system(f'notify-send --app-name="LanyxSoft liOS" --urgency="normal" --icon="/home/kali/Environments/Icons/1920x1080/icon-success.jpg" "School Attendance Automation Status" "Automation Complete with completion status: {ATTENDANCE_TAKEN}"')



