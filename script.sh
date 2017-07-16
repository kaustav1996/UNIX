#!/bin/bash
OS=$(lsb_release -si);
VR=$(lsb_release -sr);
if [[ "$OS" == "Ubuntu" ]]; then
	echo -e "123\n123" | sudo passwd  root ;
	sudo apt-get update;
	sudo apt-get -y install chromium-browser flashplugin-installer firefox xfce4 xrdp ;
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome-stable_current_amd64.deb;
	sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb;sudo apt-get -y install -f;
	rm /tmp/google-chrome-stable_current_amd64.deb;
	sudo chmod a=rwx /etc/chromium-browser/default;
	echo "CHROMIUM_FLAGS=\" --user-data-dir --no-sandbox\"" >  /etc/chromium-browser/default ;
	echo "chromium-browser --no-sandbox http://google.com&" >> ~/a ;
	echo "google-chrome --no-sandbox &" >> ~/c ;
	chmod +x ~/a ~/c;
	echo xfce4-session >~/.xsession;
	sudo sed -i.bak '/fi/a #edit \n startxfce4 \n' /etc/xrdp/startwm.sh;
	sudo chmod a=rwx /etc/xdg/autostart/xscreensaver.desktop;
	sudo sed -i.bak '/Exec/c Exec=google-chrome --no-sandbox http://www.gmail.com' /etc/xdg/autostart/xscreensaver.desktop;
	sudo chmod -R a=rwx /root/ ;
	sudo echo -e "google-chrome --no-sandbox http://www.gmail.com" > /root/Desktop/chrome.sh;
	sudo echo -e "chromium-browser --no-sandbox http://www.gmail.com" > /root/Desktop/chromium_browser.sh;
	sudo echo -e "firefox http://www.gmail.com" > /root/Desktop/firefox.sh;
	sudo chmod +x /root/Desktop/chrome.sh;
	sudo chmod +x /root/Desktop/chromium_browser.sh;
	sudo chmod +x /root/Desktop/firefox.sh;
	sudo service xrdp restart;
	ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/';
	alias extip='dig +short myip.opendns.com @resolver1.opendns.com';
	echo "Internal IP: ";
	ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/';
	echo "External IP: ";
	extip;
	echo "Operating System: " $OS $VR
	city=$(curl ipinfo.io/city/$extip);
	region=$(curl ipinfo.io/region/$extip);
	country=$(curl ipinfo.io/country/$extip);
	latlong=$(curl ipinfo.io/loc/$extip);
	echo "Location : " $city " , " $region " , " $country " . Latitude , Longitude --> " $latlong
else
	echo "Error!! Operating System Not Supported"
fi