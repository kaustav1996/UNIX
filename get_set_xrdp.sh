function setup_centos7(){
	
	# Setup function for desktop envirnment[xfce]
	# This function is responsible for setting the desktop-environment on the centos7(mini/core)
	# This function checks for desktop environment and runs only when no desktop environment is present or in session(should be run on runLvl:3).
	# The checking of desktop-session is done using the $DESKTOP_SESSION env variable.
	function install_desktop_env(){
		if [ -z "$DESKTOP_SESSION" ] 
		then 
			echo "Installing a fresh Desktop Environment.."	
		else
			echo "$DESKTOP_SESSION : Desktop Environment already installed.";exit
		fi
		yum -y install git net-tools
		
		yum -y install epel-release
		yum -y localinstall --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-7.noarch.rpm	
		
		yum -y groupinstall "X Window system"
		
		# installing [xfce] desktop environmet
		# to have a different desktop-environment change this package names and the following session commandd with it.
		yum -y groupinstall "xfce"
		echo xfce4-session > $USER_HOME/.Xclients
		chmod +x $USER_HOME/.Xclients
		# --------------

		# starting the graphical envirnment
		systemctl set-default graphical.target

	}
	
	# Setup function for xrdp server.
	# This function checks for the desktop-envirnment and installs the [xrdp server] only when the desktop envirnment is not gnome.
	# xrdp is not supported for (gnome/unity) and can cause issues in future so better not install in them.
	# for centos xrdp from a specify package works with no issue (so manually installed.)
	# This also prevents it from getting installed it from other repositories.
	function install_xrdp(){
	
		if [ "$DESKTOP_SESSION" == "gnome" ]
		then
			echo "Xrdp not suppored for gnome desktops."
			exit
		else
			echo "Installing Xrdp for $DESKTOP_SESSION ..."
		fi	

			yum -y install wget tigervnc-server			

			wget -P	$PWD http://li.nux.ro/download/nux/dextop/el7/x86_64/xrdp-0.6.1-3.el7.nux.x86_64.rpm
			wget -P $PWD http://li.nux.ro/download/nux/dextop/el7/x86_64/xrdp-debuginfo-0.6.1-3.el7.nux.x86_64.rpm

			rpm -ivh $PWD/xrdp-0.6.1-3.el7.nux.x86_64.rpm
			rpm -ivh $PWD/xrdp-debuginfo-0.6.1-3.el7.nux.x86_64.rpm
				
			rm -f $PWD/xrdp-0.6.1-3.el7.nux.x86_64.rpm
			rm -f $PWD/xrdp-debuginfo-0.6.1-3.el7.nux.x86_64.rpm
			
			systemctl restart xrdp.service
			systemctl enable xrdp.service

			firewall-cmd --permanent --zone=public --add-port=3389/tcp
			firewall-cmd --reload

			chcon --type=bin_t /usr/sbin/xrdp
			chcon --type=bin_t /usr/sbin/xrdp-sesman
			


			systemctl restart xrdp.service


	}
	
	# Setup function for other extra packages.
	# This installs other extra packages specified in this fucntion.
	function install_extra_packages(){
	
			echo "Installing extra packages ..."
			
			yum -y install chromium
			yum -y install firefox
			yum -y install xdotool	
			
			# google chrome has some issues with centod7 so installing it manually
			wget -P $PWD https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
			yum -y install $PWD/google-chrome-stable_current_x86_64.rpm
			rm -f $PWD/google-chrome-stable_current_x86_64.rpm			
			
			# setting google-chrome to automatically be called when a user makes connection using rdp [mstms]
			# basically adding commands to .bash_profile file which is been executed by the xrdp (startwm.sh)
			# and also backing up the ~/.bash_profile file . 
			cp $USER_HOME/.bash_profile $USER_HOME/.bash_profile.bk
			echo "#Custom commands to be executed on login." >> $USER_HOME/.bash_profile
			echo "google-chrome https://gmail.com &" >> $USER_HOME/.bash_profile
		}

	# display function which displays information regarding the system.
	# information displayed are [Public IP, Os_name, Location of the ip]
	function display_info(){
		#install geoip to get the location using ip.
		yum -y install geoip
	
		echo -e "\n\n############################### INFO ###############################"
		echo -e "OS NAME :\n $OS_NAME"
		ip=$(curl ipecho.net/plain 2>/dev/null)
		echo -e "Public IP:\n$ip"
		echo -e "IP location:"
		geoiplookup $ip
		echo "####################################################################"
	}
	
	# stores the path to the user directory ,by which the script was executed.
	USER_HOME=$(eval echo ~$SUDO_USER)
	
	# calling the setup functions individually
	echo "================================================================"
	echo "Install Desktop env ..."
	echo "================================================================"
	install_desktop_env
	

	echo "================================================================"
	echo "Install xrdp server ..."
	echo "================================================================"
	install_xrdp
	

	echo "================================================================"
	echo "installing Extra packages ..."
	echo "================================================================"
	install_extra_packages

	echo "++++++++++++++++++++++++++++++++ DONE ++++++++++++++++++++++++++++++++\n"
	
	display_info	

	# change run level to 5(GUI with networking mode.)
	systemctl isolate graphical.target
}

#### =======================================================================================

#### UBUNTU PART IS NOT TESTED PROPERLY YET.

#### UBUNTU 17.04 setup function -----------------------------------------------------

function setup_ubuntu1704(){
	
	
	function install_desktop_env(){

		if [ -z "$DESKTOP_SESSION" ] 
		then 
			echo "Installing a fresh Desktop Environment.."	
		else
			echo "$DESKTOP_SESSION : Desktop Environment already installed.";exit
		fi

		apt-get -y install net-tools
		apt-get -y install xubuntu-desktop
		
		
	
	}

	function install_xrdp(){
	
		if [ "$DESKTOP_SESSION" == "gnome" ] && [ "$DESKTOP_SESSION"=="ubuntu" ]
		then
			echo "Xrdp not suppored for gnome/unity desktops."
			exit
		else
			echo "Installing Xrdp for $DESKTOP_SESSION ..."
		fi	


		apt-get -y install xrdp
		
		echo xfce4-session > $USER_HOME/.xsession
		ufw allow 3389/tcp
	
		sed -i.bak '/fi/a #xrdp multiple users configuration \n startxfce4 \n' /etc/xrdp/startwm.sh
	
		systemctl restart xrdp.service	
		systemctl enable xrdp
	}

	function install_extra_packages(){
		
		apt-get -y install wget
		apt -y install firefox 
		apt -y install chromium-browser
		wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - 
		sh -c 'echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
		apt-get update
		apt-get -y install google-chrome-stable

	}


	install_desktop_env
	install_xrdp
	install_extra_packages
	

}
#### =======================================================================================

# This function changes the root password.
function change_passwd(){
		
	# changing password for the root
	echo -e "easypassword\neasypassword" | passwd root

	# changing the password of user who executed this script.	
	#echo -e "easypassword\neasypassword" | passwd $SUDO_USER

}


# AUTO-DETECTE'S THE CURRENT OS NAME AND VERSION OF THE SYSTEM IN WHICH THE SCRIPT IS RUNNING.
# This is done by looking at the /etc/os-release file.
# This file is virtually present on every linux distro

# OS_NAME is the combination of both (NAME, VERSION) fields from the os-release file. 

OS_ID=`cat /etc/os-release | grep -oP '^NAME="\K[^"]+'`
OS_VERSION=`cat /etc/os-release | grep -oP '^VERSION_ID="\K[^"]+'`
OS_NAME="$OS_ID $OS_VERSION"

echo "OS Ditected : $OS_NAME.."
echo "-----------------------------------"

echo "Changing the roots password..."
change_passwd
echo "------------------------------"

# when an specified OS_NAME is detected, the function specified for it ies executed.
# as bash in interpreted, it will execute only the function specified for that os
# hence a comman script-file can be used accross multiple-systems.
#
#
#	Support for a specific linux system can be specified by 
#	1: creating a function containing the script for that os
#	2: adding the os_name in the below switch-case and calling the repective function for in it.
#
case $OS_NAME in 
	"Ubuntu 17.04")
		echo "$OS_NAME Selected."
		
		setup_ubuntu1704		
		;;

	"CentOS Linux 7")
		echo "$OS_NAME Selected"
		
		setup_centos7
		;;

	*)
		echo "$OS_NAME not supported yet."
		;;

esac
