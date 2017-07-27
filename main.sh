P='default' #default password
U='root' #default user
SERVER='xrdp' # default server
OS_ID='Ubuntu' #default os name
OS_VERSION='17.04' #default os version
OS_NAME='$OS_ID $OSVERSION'
STARTUP_BROWSER='chrome' #default browser
STARTUP_WEBSITE='www.gmail.com' #default website to open in browser
BOWSER_CODE='google-chrome --no-sandbox www.gmail.com'
browser_exec()
{
	if [[ "$STARTUP_BROWSER" == "chrome" ]]; then
		BROWSER_CODE=google-chrome --no-sandbox $STARTUP_WEBSITE
	elif [[ "$STARTUP_BROWSER" == "chromium" ]]; then
		BROWSER_CODE=chromium-browser --no-sandbox $STARTUP_WEBSITE
	elif [[ "$STARTUP_BROWSER" == "firefox" ]]; then
		BROWSER_CODE=firefox $STARTUP_WEBSITE
	else
		echo "ERROR!! BROWSER NOT AVAILABLE!!"
	fi
}
detect_os()
{
	OS_ID=`cat /etc/os-release | grep -oP '^NAME="\K[^"]+'`
	OS_VERSION=`cat /etc/os-release | grep -oP '^VERSION_ID="\K[^"]+'`
	OS_NAME="$OS_ID $OS_VERSION"
	echo "-----------------------------------"
	echo "OS Ditected : $OS_NAME"
	echo "-----------------------------------"
}
install_extra_packages()
{
	if [[ "$OS" == "Ubuntu" ]]; then
		sudo apt-get -y install chromium-browser browser-plugin-freshplayer-pepperflash firefox ;
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
	elif [[ "$OS" == "CentOS Linux" ]]; then
		sudo yum -y install wget chromium-browser browser-plugin-freshplayer-pepperflash firefox ;
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
	echo "External IP: ";
	dig +short myip.opendns.com @resolver1.opendns.com;
	echo "Operating System: " $OS $VR;
	
	echo "Location : " $city " , " $region " , " $country " . Latitude , Longitude --> " $latlong;
}
startup_settings()
{
	sudo chmod -R a=rwx /etc/xdg/autostart/ ; #granting permission to edit autostart
	echo -e "[Desktop Entry]\nName=Terminal_autostart\nExec=xterm\nType=Application" >>/etc/xdg/autostart/term.desktop; #terminal would start at start up
	sudo chmod +x /etc/xdg/autostart/term.desktop;
	echo -e "[Desktop Entry]\nName=Chrome_autostart\nExec=google-chrome --no-sandbox www.gmail.com\nType=Application" >>/etc/xdg/autostart/chrome.desktop; #chrome would start at start up
	sudo chmod +x /etc/xdg/autostart/chrome.desktop;
}
install_desktop()
{
	if [[ "$OS" == "Ubuntu" ]]; then
		if [[ "$SERVER" == "xrdp" ]]; then
		
			sudo apt-get -y install xrdp xfce4 xfce4-goodies;
			echo xfce4-session >~/.xsession;
			sudo sed -i.bak '/fi/a #edit \n startxfce4 \n' /etc/xrdp/startwm.sh;
		else
			sudo apt-get -y install vnc4server autocutsel;
			sudo apt-get -y install xfce4 xfce4-goodies;
			echo -e "12345678\n12345678" | sudo vncserver -geometry 1600x900 -depth 24; 
			sudo sed -i.bak '/x-terminal-emulator/c startxfce4 & \n' ~/.vnc/xstartup;
			sudo vncserver -kill :1;
			sudo vncserver -geometry 1600x900 -depth 24;
	if [[ "$OS" == "CentOS Linux" ]]; then
		if [[ "$SERVER" == "xrdp" ]]; then
		
			sudo yum -y install xrdp xfce4 xfce4-goodies;
			echo xfce4-session >~/.xsession;
			sudo sed -i.bak '/fi/a #edit \n startxfce4 \n' /etc/xrdp/startwm.sh;
		else
			sudo yum -y install vnc4server autocutsel;
			sudo yum -y install xfce4 xfce4-goodies;
			echo -e "12345678\n12345678" | sudo vncserver -geometry 1600x900 -depth 24; 
			sudo sed -i.bak '/x-terminal-emulator/c startxfce4 & \n' ~/.vnc/xstartup;
			sudo vncserver -kill :1;
			sudo vncserver -geometry 1600x900 -depth 24;
	else
		echo "ERROR OS NOT SUPPORTED YET!!"
	fi
		
}
echo "###################################################################"
read -p "Enter Username(type-> root , if u want to enter desktop as root) >> " U
read -p "Enter Password >> " P
echo -e "$P\n$P" | sudo passwd $U
detect_os
read -p "What server do you want to install? (xrdp/vnc) >> " SERVER
read -p "Which Browser do you want to open after login ? (chrome/chromium/firefox) >> " STARTUP_BROWSER
read -p "Which Website do you want to open at startup? (example:- www.gmail.com) >> " STARTUP_WEBSITE
browser_exec
install_desktop
startup_settings
install_extra_packages
machine_info
echo "###################################################################"
