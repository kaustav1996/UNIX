#!/bin/bash
#################################################
#
# Script name 	: macro.sh
# Description	: repeats a perticular steps on gmail on a given browser.
# Note		: should be runned by user after he has opened the browser and login in it
#		  make sure the browser window is maximized and then execute this script in a given terminal and 
#		  then make sure the browser window is in front.	
# Author 	: undefined
#
#################################################


##
## This script macro the given steps on gmail.com
## 	1: moves the cursor to x:500 y:400 and scroll downs in the inbox.
##	2: reloads the main if a perticular number of time executed.(default 10)
##	3: click and opens the mail below the cursor into a new-tab.
##	4: switch's to that tab and reloads it.
##	5: closes that tab and goes back to the main tab.
##	6: scroll down and repeats the steps from [step-2]

# counts the number of time executed a sequnce.
count=1

# do untill stopped by user using ctrl+c
while [ 1 ]
do	
	# Execute with an interval of given secound (1m==60sec).	
	# change according to ur need.
	sleep 300	

	count=$(( $count + 1 ))
	
	check=$(( $count % 3 ))
	echo "$count"
	sleep 10
	
	# reload the current page after executing the sequence 'n' time .
	if [ $check -eq "0" ]
	then
		echo "-------------------"
		xdotool key F5
		sleep 5
		xdotool key Return
	fi
	
	xdotool mousemove 500 400 click 5
	xdotool keydown ctrl
	xdotool click 1
	xdotool keyup ctrl	
	sleep 10

	xdotool key alt+2
	xdotool key F5
	sleep 5
	xdotool key Return
	sleep 10
	xdotool key ctrl+w

	

done

