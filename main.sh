P='default' #default password
U='root' #default user
SERVER='xrdp' # default server
OS_ID='Ubuntu' #default os name
OS_VERSION='17.04' #default os version
OS_NAME='$OS_ID $OSVERSION'
STARTUP_BROWSER='chrome' #default browser
detect_os()
{
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
	else
		echo "ERROR OS NOT SUPPORTED YET!!"
	fi
}
machine_info()
{
	
	alias extip='dig +short myip.opendns.com @resolver1.opendns.com';
	city=$(curl ipinfo.io/city/$extip);
	region=$(curl ipinfo.io/region/$extip);
	country=$(curl ipinfo.io/country/$extip);
	latlong=$(curl ipinfo.io/loc/$extip);
	echo "Internal IP: ";
	ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/';
	ip=$(curl ipecho.net/plain 2>/dev/null)
	echo -e "Public IP:\n$ip"
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
			sudo chmod -R a=rwx /etc/xdg/autostart/ ; #granting permission to edit autostart
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
	else
		echo "ERROR OS NOT SUPPORTED YET!!"
	fi
		
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
	fi

}
echo "###################################################################"
read -p "Enter Username(type-> root , if u want to enter desktop as root) >> " U
read -p "Enter Password(use atleast 8 characters/numbers) >> " P #as this password will be also used for vncserver if chosen
echo -e "$P\n$P" | sudo passwd $U
detect_os
read -p "What server do you want to install? (xrdp/vnc) >> " SERVER
read -p "Which Browser do you want to open after login ? (chrome/chromium/firefox) >> " STARTUP_BROWSER
install_extra_packages
install_desktop
startup_settings
restart_service
machine_info
echo "###################################################################"
