#!/bin/bash

#################################################
#
# Script name 	: set_browser.sh
# Description	: make a browser auto lauched when login by a user 
# Note 	        : its recommemded to run this script using 'manager.sh' with browser option 
#			following the browser to make auto lauched name.
#
#			eg: to make firefox as default launch use.
#							
#			$ manager -browser firefox	
#
# Author 	: undefined
#
#################################################

# Array to store the supported browser and their following commands.
declare -A browsers
browsers["chrome"]="google-chrome"
browsers["chromium"]="chromium-browser"
browsers["firefox"]="firefox"

# Function init_browser changes the browser which auto lanches at login time by modifing the .bash_profile file.
# Take an argument of the browser_name to be lauched at login time and set it.

function init_browser(){
	# check if browser supported.
	if [ -z "${browsers[$1]}" ] 
	then
		echo "$1 Not Supported ."
		exit
	else

		echo "${browsers[$1]} Browser Selected ."
		
		# check if script runned under sudo or by root. 
		if [ -z "$SUDO_USER" ]
		then
			# If run by normal user.
			cp ~/.bash_profile.bk ~/.bash_profile
			echo "#Custom commands to be executed on login." >> ~/.bash_profile
			echo "${browsers[$1]} https://gmail.com &" >> ~/.bash_profile
		
		else
			# if run by root user.
		
			USER_HOME=$(eval echo ~$SUDO_USER)
			cp $USER_HOME/.bash_profile.bk $USER_HOME/.bash_profile
			echo "#Custom commands to be executed on login." >> $USER_HOME/.bash_profile
			echo "${browsers[$1]} https://gmail.com &" >> $USER_HOME/.bash_profile
		
		fi

	fi
}

# pass argument of the browser to change to the function.
init_browser $1
