P='default' #default password
U='root' #default user
SERVER='xrdp' # default server
OS_ID='Ubuntu' #default os name
OS_VERSION='17.04' #default os version
OS_NAME='$OS_ID $OSVERSION'
STARTUP_BROWSER='chrome' #default browser
detect_os()
{	
	sudo apt-get -y install python-minimal
	OS_ID=$(python -c 'import platform ; print platform.dist()[0]')
	OS_VERSION=$(python -c 'import platform ; print platform.dist()[1]')
	OS_NAME="$OS_ID $OS_VERSION"
	echo "-----------------------------------"
	echo "OS Ditected : $OS_NAME"
	echo "-----------------------------------"
}
install_extra_packages()
{
	if [[ "$OS_ID" == "Ubuntu" ]]; then
		sudo apt-get update;
		if [[ "$OS_VERSION" == "14.04" ]]; then
			sudo apt-get -y install chromium-browser firefox flashplugin-installer;
		else
			sudo apt-get -y install chromium-browser firefox browser-plugin-freshplayer-pepperflash ;
		fi
		wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome-stable_current_amd64.deb;
		sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb;sudo apt-get -y install -f; #installing chrome
		rm /tmp/google-chrome-stable_current_amd64.deb;
		sudo chmod a=rwx /etc/chromium-browser/default;
		sudo chmod -R a=rwx /home/;
		echo "CHROMIUM_FLAGS=\" --user-data-dir --no-sandbox\"" >  /etc/chromium-browser/default ;
		echo -e "[Desktop Entry]\nName=chrome\nExec=google-chrome --no-sandbox www.gmail.com\nType=Application" >> /home/chrome.desktop
		echo -e "[Desktop Entry]\nName=chromium\nExec=chromium-browser www.gmail.com\nType=Application" >> /home/chromium.desktop
		echo -e "[Desktop Entry]\nName=firefox\nExec=firefox www.gmail.com\nType=Application" >> /home/firefox.desktop
		chmod +x /home/chromium.desktop;
		chmod +x /home/chrome.desktop;
		chmod +x /home/firefox.desktop;
	elif [[ "$OS_ID" == "centos" ]]; then
		sudo yum -y install chromium
		sudo yum -y install firefox
		sudo yum -y install xdotool	
		# google chrome has some issues with centod7 so installing it manually
		sudo wget -P $PWD https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
		sudo yum -y install $PWD/google-chrome-stable_current_x86_64.rpm
		sudo rm -f $PWD/google-chrome-stable_current_x86_64.rpm		
		
		# setting google-chrome to automatically be called when a user makes connection using rdp [mstms]
		# basically adding commands to .bash_profile file which is been executed by the xrdp (startwm.sh)
		# and also backing up the ~/.bash_profile file . 
		echo -e "[Desktop Entry]\nName=chrome\nExec=google-chrome --no-sandbox www.gmail.com\nType=Application" >> /home/chrome.desktop
		echo -e "[Desktop Entry]\nName=chromium\nExec=chromium-browser www.gmail.com\nType=Application" >> /home/chromium.desktop
		echo -e "[Desktop Entry]\nName=firefox\nExec=firefox www.gmail.com\nType=Application" >> /home/firefox.desktop
		chmod +x /home/chromium.desktop;
		chmod +x /home/chrome.desktop;
		chmod +x /home/firefox.desktop;
	elif [[ "$OS_ID" == "debian" ]]; then
		sudo apt -y install chromium
		sudo apt -y install firefox-esr
		wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome-stable_current_amd64.deb;
		sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb;sudo apt-get -y install -f; #installing chrome
		rm /tmp/google-chrome-stable_current_amd64.deb;
		sudo chmod a=rwx /etc/chromium-browser/default;
		sudo chmod -R a=rwx /home/;
		echo -e "[Desktop Entry]\nName=chrome\nExec=google-chrome --no-sandbox www.gmail.com\nType=Application" >> /home/chrome.desktop
		echo -e "[Desktop Entry]\nName=chromium\nExec=chromium www.gmail.com\nType=Application" >> /home/chromium.desktop
		echo -e "[Desktop Entry]\nName=firefox\nExec=firefox www.gmail.com\nType=Application" >> /home/firefox.desktop
		chmod +x /home/chromium.desktop;
		chmod +x /home/chrome.desktop;
		chmod +x /home/firefox.desktop;
	else
		echo "ERROR OS NOT SUPPORTED YET!!"
	fi
}
machine_info()
{
	
	alias extip=$(curl ipecho.net/plain 2>/dev/null);
	city=$(curl ipinfo.io/city/$extip);
	region=$(curl ipinfo.io/region/$extip);
	country=$(curl ipinfo.io/country/$extip);
	latlong=$(curl ipinfo.io/loc/$extip);
	echo "Internal IP: ";
	ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/';
	ip=$(curl ipecho.net/plain 2>/dev/null)
	echo -e "External IP:\n$ip"
	echo "Operating System: " $OS $VR;
	
	echo "Location : " $city " , " $region " , " $country " . Latitude , Longitude --> " $latlong;
}
startup_settings()
{
		if [[ "$OS_ID" == "centos" ]]; then
			sudo cp $HOME/.bash_profile $HOME/.bash_profile.bk
			
			if [[ "$STARTUP_BROWSER" == "chrome" ]]; then
				echo "google-chrome https://gmail.com &" >> ~/.bash_profile
			elif [[ "$STARTUP_BROWSER" == "chromium" ]]; then
				echo "chromium https://gmail.com &" >> ~/.bash_profile
			elif [[ "$STARTUP_BROWSER" == "firefox" ]]; then
				echo "firefox https://gmail.com &" >> ~/.bash_profile
			else
				echo "ERROR!! BROWSER NOT AVAILABLE!!"
			fi
		elif [[ "$OS_ID" == "Ubuntu" ]]; then
			sudo chmod -R a=rwx /etc/xdg/autostart/ ; #granting permission to edit autostart
			if [[ "$STARTUP_BROWSER" == "chrome" ]]; then
				echo -e "[Desktop Entry]\nName=Chrome_autostart\nExec=google-chrome --no-sandbox www.gmail.com\nType=Application" >>/etc/xdg/autostart/chrome.desktop; #chrome would start at start up
				sudo chmod +x /etc/xdg/autostart/chrome.desktop;
			elif [[ "$STARTUP_BROWSER" == "chromium" ]]; then
				echo -e "[Desktop Entry]\nName=Chromium_autostart\nExec=chromium-browser --no-sandbox www.gmail.com\nType=Application" >>/etc/xdg/autostart/chromium.desktop; #chrome would start at start up
				sudo chmod +x /etc/xdg/autostart/chromium.desktop;
			elif [[ "$STARTUP_BROWSER" == "firefox" ]]; then
				echo -e "[Desktop Entry]\nName=Firefox_autostart\nExec=firefox www.gmail.com\nType=Application" >>/etc/xdg/autostart/fox.desktop; #chrome would start at start up
				sudo chmod +x /etc/xdg/autostart/fox.desktop;
			else
				echo "ERROR!! BROWSER NOT AVAILABLE!!"
			fi
			if [[ "$4" == "1" ]]; then
				echo -e "[Desktop Entry]\nName=Terminal_autostart\nExec=xterm\nType=Application" >>/etc/xdg/autostart/term.desktop; #terminal would start at start up
			else
				echo -e "[Desktop Entry]\nName=Terminal_autostart\nExec=lxterminal\nType=Application" >>/etc/xdg/autostart/term.desktop; #terminal would start at start up
			fi
			sudo chmod +x /etc/xdg/autostart/term.desktop;
		elif [[ "$OS_ID" == "debian" ]]; then
			sudo chmod -R a=rwx /etc/xdg/autostart/ ; #granting permission to edit autostart
			if [[ "$STARTUP_BROWSER" == "chrome" ]]; then
				echo -e "[Desktop Entry]\nName=Chrome_autostart\nExec=google-chrome --no-sandbox www.gmail.com\nType=Application" >>/etc/xdg/autostart/chrome.desktop; #chrome would start at start up
				sudo chmod +x /etc/xdg/autostart/chrome.desktop;
			elif [[ "$STARTUP_BROWSER" == "chromium" ]]; then
				echo -e "[Desktop Entry]\nName=Chromium_autostart\nExec=chromium --no-sandbox www.gmail.com\nType=Application" >>/etc/xdg/autostart/chromium.desktop; #chrome would start at start up
				sudo chmod +x /etc/xdg/autostart/chromium.desktop;
			elif [[ "$STARTUP_BROWSER" == "firefox" ]]; then
				echo -e "[Desktop Entry]\nName=Firefox_autostart\nExec=firefox www.gmail.com\nType=Application" >>/etc/xdg/autostart/fox.desktop; #chrome would start at start up
				sudo chmod +x /etc/xdg/autostart/fox.desktop;
			else
				echo "Browser not supported!!"
			fi
			
			echo -e "[Desktop Entry]\nName=Terminal_autostart\nExec=xterm\nType=Application" >>/etc/xdg/autostart/term.desktop; #terminal would start at start up
			sudo chmod +x /etc/xdg/autostart/term.desktop;
		fi

}
install_desktop()
{
	if [[ "$OS_ID" == "Ubuntu" ]]; then
		if [[ "$SERVER" == "xrdp" ]]; then
			sudo apt-get update;
			sudo apt-get -y install xrdp xfce4 xfce4-goodies;
			echo xfce4-session >~/.xsession;
			sudo sed -i.bak '/fi/a #edit \n startxfce4 \n' /etc/xrdp/startwm.sh;
			if [[ "$OS_VERSION" == "16.04" ]]; then
				sudo cp .xsession /etc/skel/;
				sudo sed -i.bak '/port/c port=ask-1' /etc/xrdp/xrdp.ini;
			elif [[ "$OS_VERSION" == "14.04" ]]; then
				sudo cp .xsession /etc/skel/;
				sudo sed -i.bak '/port/c port=ask-1' /etc/xrdp/xrdp.ini;
			fi
		else
			sudo apt-get -y install vnc4server autocutsel;
			sudo apt-get -y install xfce4 xfce4-goodies;
			echo -e "$P\n$P" | sudo vncserver -geometry 1600x900 -depth 24; 
			sudo sed -i.bak '/x-terminal-emulator/c startxfce4 & \n' ~/.vnc/xstartup;
			sudo vncserver -kill :1;
			sudo vncserver -geometry 1600x900 -depth 24;
		fi
	elif [[ "$OS_ID" == "centos" ]]; then
		if [[ "$SERVER" == "xrdp" ]]; then
			sudo yum -y install git net-tools
		
			sudo yum -y install epel-release
			sudo yum -y localinstall --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-7.noarch.rpm	
			
			sudo yum -y groupinstall "X Window system"
			
			# installing [xfce] desktop environmet
			# to have a different desktop-environment change this package names and the following session commandd with it.
			sudo yum -y groupinstall "xfce"
			sudo echo xfce4-session > $HOME/.Xclients
			sudo chmod +x $HOME/.Xclients
			# --------------

			# starting the graphical envirnment
			sudo systemctl set-default graphical.target
			sudo yum -y install wget tigervnc-server			

			sudo wget -P	$PWD http://li.nux.ro/download/nux/dextop/el7/x86_64/xrdp-0.6.1-3.el7.nux.x86_64.rpm
			sudo wget -P $PWD http://li.nux.ro/download/nux/dextop/el7/x86_64/xrdp-debuginfo-0.6.1-3.el7.nux.x86_64.rpm

			sudo rpm -ivh $PWD/xrdp-0.6.1-3.el7.nux.x86_64.rpm
			sudo rpm -ivh $PWD/xrdp-debuginfo-0.6.1-3.el7.nux.x86_64.rpm
				
			sudo rm -f $PWD/xrdp-0.6.1-3.el7.nux.x86_64.rpm
			sudo rm -f $PWD/xrdp-debuginfo-0.6.1-3.el7.nux.x86_64.rpm
			
			sudo systemctl restart xrdp.service
			sudo systemctl enable xrdp.service

			sudo firewall-cmd --permanent --zone=public --add-port=3389/tcp
			sudo firewall-cmd --reload

			sudo chcon --type=bin_t /usr/sbin/xrdp
			sudo chcon --type=bin_t /usr/sbin/xrdp-sesman
			


			sudo systemctl restart xrdp.service

		else
			sudo yum -y install vnc4server autocutsel;
			sudo yum -y install xfce4 xfce4-goodies;
			echo -e "12345678\n12345678" | sudo vncserver -geometry 1600x900 -depth 24; 
			sudo sed -i.bak '/x-terminal-emulator/c startxfce4 & \n' ~/.vnc/xstartup;
			sudo vncserver -kill :1;
			sudo vncserver -geometry 1600x900 -depth 24;
		fi
	elif [[ "$OS_ID" == "debian" ]]; then
		sudo apt-get update
		sudo apt -y install xrdp
		sudo systemctl start xrdp
		sudo systemctl enable xrdp
		sudo apt -y install xfce4
		sudo apt -y install xfce4-goodies
		sudo apt-get -f install
		echo xfce4-session >~/.xsession;
		sudo sed -i.bak '/fi/a #edit \n startxfce4 \n' /etc/xrdp/startwm.sh;

	else
		echo "ERROR OS NOT SUPPORTED YET!!"
	fi
		
}
automation_kit()
{
	sudo apt -y install python-pip git
	sudo pip install selenium
	cd /home
	sudo apt-get -f install
	sudo git clone https://github.com/kaustav1996/Automation
	sudo cp Automation/chromedriver /
	sudo chmod +x /chromedriver


}
restart_service()
{	
	if [[ "$OS_ID" == "Ubuntu" ]]; then
		if [[ "$SERVER" == "xrdp" ]]; then
			sudo service xrdp restart;
		else
			sudo vncserver -kill :1;
			echo -e "$P\n$P" | sudo vncserver -geometry 1600x900 -depth 24;
		fi
	elif [[ "$OS_ID" == "centos" ]]; then
		sudo systemctl restart xrdp.service
		sudo systemctl isolate graphical.target
	elif [[ "$OS_ID" == "debian" ]]; then
		sudo service xrdp restart;
	fi

}
echo "###################################################################"
if [[ "$1" == "1" ]]; then
	U='root'
else
	U="$1"
fi
if [[ "$2" == "1" ]]; then
	P='akshay@123'  #as this password will be also used for vncserver if chosen
else
	P="$2"
fi
echo -e "$P\n$P" | sudo passwd $U
detect_os
if [[ "$3" == "1" ]]; then
	SERVER='xrdp'
else
	U="vnc"
fi
if [[ "$3" == "1" ]]; then
	STARTUP_BROWSER='chrome'
else
	if [[ "$3" == "2" ]]; then
		STARTUP_BROWSER='firefox'
	else
		STARTUP_BROWSER='chromium'
	fi
fi
if [[ "$4" == "1" ]]; then
	install_extra_packages
	install_desktop
	startup_settings
	restart_service
	automation_kit
	machine_info
	echo "###################################################################"
else
	sudo apt-get update;
	if [[ "$OS_VERSION" == "14.04" ]]; then
		sudo apt-get -y install lxde ubuntu-gnome-desktop tightvncserver xrdp chromium-browser firefox flashplugin-installer;
	else
		sudo apt-get -y install lxde ubuntu-gnome-desktop tightvncserver xrdp chromium-browser firefox browser-plugin-freshplayer-pepperflash; # installing desktop and browsers and plugins
	fi
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome-stable_current_amd64.deb;
	sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb;sudo apt-get -y install -f; #installing chrome
	rm /tmp/google-chrome-stable_current_amd64.deb;
	sudo chmod a=rwx /etc/chromium-browser/default;
	sudo chmod -R a=rwx /home/;
	echo "CHROMIUM_FLAGS=\" --user-data-dir --no-sandbox\"" >  /etc/chromium-browser/default ;
	echo -e "[Desktop Entry]\nName=chrome\nExec=google-chrome --no-sandbox www.gmail.com\nType=Application" >> /home/chrome.desktop
	echo -e "[Desktop Entry]\nName=chromium\nExec=chromium-browser www.gmail.com\nType=Application" >> /home/chromium.desktop
	echo -e "[Desktop Entry]\nName=firefox\nExec=firefox www.gmail.com\nType=Application" >> /home/firefox.desktop
	chmod +x /home/chromium.desktop;
	chmod +x /home/chrome.desktop;
	chmod +x /home/firefox.desktop;
	echo lxsession -s LXDE -e LXDE > ~/.xsession ;
	automation_kit # selenium dependencies and git repository download
	startup_settings
	echo  sudo /etc/init.d/xrdp restart ; #restart
	machine_info
fi
#################################################################################################################################################################################
#############################################################################################################################################################################
#
#  sudo bash main.sh [1 for root / username] [1 for password akshay@123 / password ] [1 = xrdp / 2 = vnc] [ 1 for GCP / 2 for my.vultr]
#
#  ***********************************************************************************************************************************************************************
#
#  -----------------------------------------------------------------------KAUSTAV-----------BANERJEE---------[KGEC]---------------------------------------------------
#
#  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#
#  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%