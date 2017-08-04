#!/bin/bash

#################################################
#
# Script name 	: manager.sh
# Description	: (main script file which should be used to execute other scripts.)
#			 - auto updates all scripts.
#			 - install and setups xrdp, desktop-env , browser, *
#			 - changes the default browser to auto launch at login.
# Author 	: undefined
#
#################################################


# Help description for the script.
# what options are avialable and their usage.
HELP="
Description :

	manager <option>

	By default
	Downloads the latest script from the given link and set them up for usage.

	[Options	: Description.]
	-init_setup	: setups the system by installing the desktop-env, xrdp, browsers.
	-browser		: setup which browser to be auto run on login.
"
# URL to the files which needs to be downloaded or checked for updates.
URL=https://raw.githubusercontent.com/kaustav1996/UNIX/master/init_scripts-master/init_scripts-master/
# Path to the current working directory of the script.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# removing old scripts.
rm $DIR/get_set_xrdp.sh 2>/dev/null 
rm $DIR/set_browser.sh 2>/dev/null
rm $DIR/macro.sh 2>/dev/null

# downloading new scripts.
curl -o $DIR/get_set_xrdp.sh $URL/get_set_xrdp.sh
curl -o $DIR/set_browser.sh $URL/set_browser.sh
curl -o $DIR/macro.sh $URL/macro.sh

# Options arguments to the scripts.

if [ "$#" -eq 0 ]
then
       # Simple script update.       
	echo "File's Updated."

elif [ "$1" == "-help" ]
then
	# Shows help option.
	echo -e "HELP\n"
	echo "$HELP"

elif [ "$#" -eq "1" ] && [ "$1" == "-init_setup" ]
then
	# Runs the script to install and setup xrdp, desktop-env, browser, *
	echo "Doing initial setups..."
	bash $DIR/get_set_xrdp.sh

elif [ "$#" -eq "2" ] && [ "$1" == "-browser" ]
then
	# Runs the script to change the default browser to execute at login time.
	echo "Changing default browser..."
	bash $DIR/set_browser.sh $2

else
	# Invailed arguments.
	echo -e "INVAILED OPTION\n"
	echo "$HELP"
fi
