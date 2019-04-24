#!/usr/bin/python
import requests
import sys
import os
import time
from colorama import Fore, Back, Style

#
# Added functionality from the python script in AWAE
# User enter site, port, Yes yes Y y for proxy and http or https
# Python requests library does the rest.
#
# Verify host and port

if len(sys.argv) != 5:
    print "[-] Four arguments, really?\n"
    print "[-] Apparently, so\n"
    print "[-] Usage: ./thisfile.py <host> <port> <proxy option> <protocol>\n"
    print "[-] Example ./thisfile.py manageengine 8443 no https\n"
    sys.exit()


# Define sys arguments
host=sys.argv[1]
port=sys.argv[2]
useproxy=sys.argv[3]
protocol=sys.argv[4]

# Define proxies
proxies = {'http':'http://127.0.0.1:8080','https':'http://127.0.0.1:8080'}

# This will blank out some of the  warning we do not need
# Like SSL cert not known

requests.packages.urllib3.disable_warnings(requests.packages.urllib3.exceptions.InsecureRequestWarning)

# This makes the text "pretty"

def format_text(title,item):
	cr = "\r\n"
	section_break = cr + "*" * 20 +cr
	item = str(item)
	text = Style.BRIGHT + Fore.RED + title + Fore.RESET + section_break + item + section_break
	return text;


if useproxy in [ 'Yes', 'yes', 'Y', 'y']:
        r = requests.get(protocol+ "://"  + host + ":" + port + "/", verify=False,proxies=proxies)
	print format_text('r.status_code is: ',r.status_code)
	print format_text('r.headers is: ',r.headers)
	print format_text('r.cookies is: ',r.cookies)
	print format_text('r.text is: ',r.text)
	print "[-] Complete, check Burp or ZAP"
	sys.exit()
    
r = requests.get(protocol + "://"  + host + ":" + port + "/", verify=False)
print format_text('r.status_code is: ',r.status_code)
print format_text('r.headers is: ',r.headers)
print format_text('r.cookies is: ',r.cookies)
print format_text('r.text is: ',r.text)
print "[-] Complete"
sys.exit()
