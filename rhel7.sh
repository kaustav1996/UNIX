echo "starting the process"

#installing command tool to display os information
sudo yum install -y redhat-lsb

#checking if your os is compatible or not
lsb_release -a >/root/file1
echo "LSB Version:	:core-4.1-amd64:core-4.1-noarch:cxx-4.1-amd64:cxx-4.1-noarch:desktop-4.1-amd64:desktop-4.1-noarch:languages-4.1-amd64:languages-4.1-noarch:printing-4.1-amd64:printing-4.1-noarch
Distributor ID:	RedHatEnterpriseServer
Description:	Red Hat Enterprise Linux Server release 7.3 (Maipo)
Release:	7.3
Codename:	Maipo" > /root/file2

if diff /root/file1 /root/file2 >/dev/null ; then
  echo "SUCCESS: your os is compatible with script"
  sleep 3
else
  echo "ERROR: your os is not comapatible with script"
  exit
fi

#changing root user password to 1
echo "changing root user passwd to 1"
echo -e "1\n1"|sudo passwd root

#installing necessary packages for ip location
echo "Installing curl"
sudo yum install -y curl

#installing chromium firefox
echo "installing chromium and firefox"
sudo yum install -y chromium
sudo yum install -y firefox

#installing graphical interface for rhel7 server
sudo yum groupinstall -y 'X Window System' 'GNOME'
sudo systemctl set-default graphical.target

#installing RPC packages
echo "installing rpc package xrdp" 
sudo yum install -y xrdp
sudo systemctl start xrdp.service
sudo systemctl enable xrdp.service

#installing chrome
echo "installing chrome..."
sudo wget http://chrome.richardlloyd.org.uk/install_chrome.sh
sudo chmod u+x install_chrome.sh
sudo ./install_chrome.sh -f


#extra information to show when a user login
echo "curl ipinfo.io">>/root/.bashrc
echo "cat /root/file1">>/root/.bashrc

#making chrome to run when root user logs in
echo "making chrome to run when root user logs in"
echo "google-chrome --no-sandbox &">>/root/.bashrc
echo "sed -i '/&$/d' /root/.bashrc">>/root/.bashrc 
#making script in home dir to launch chrome firefox and chromium. For firefox the script is ~/fire , for chromium it is ~/chromium and for chrome it is ~/chrome
echo "making script in home dir to launch chrome, firefox and chromium. For firefox the script is ~/fire , for chromium it is ~/chromium and for chrome it is ~/chrome"
echo "chromium-browser --no-sandbox http://www.gmail.com">~/chromium
sudo chmod +x ~/chromium
echo "firefox http://www.gmail.com">~/fire 
sudo chmod +x ~/fire
echo "google-chrome --no-sandbox http://www.gmail.com">~/chrome
sudo chmod +x ~/chrome

#Disabling firewall
echo "Disabling firewall"
sudo systemctl stop firewalld
systemctl restart xrdp.service
systemctl enable xrdp.service

#this is the bonus feature ...execute ./bonusscript to refresh the page after every five min
echo "downloading bonusscript"
sudo yum install -y xdotool
wget -O bonusscript "https://drive.google.com/uc?export=download&id=0B1ZV-b1wBuvRSXQ0X0NYcTZsYU0"
sudo chmod +x ./bonusscript
#Following is the another way to maintain the connection to some webpage just uncomment following two lines and run ./bonus
#echo "while true; do wget -qO- http://www.google.com > /dev/null; sleep 300; done">./bonus
#sudo chmod +x ./bonus

#extra information to show when a user login
#echo "curl ipinfo.io">>/root/.bashrc
#echo "cat file1">>/root/.bashrc

#this is your ip and its location
echo "this is your ip and its location"
sudo curl ipinfo.io

#this is your os information
echo "     "
echo "    "
echo "this is your os information...."
cat /root/file1
sudo echo "INSTALLATION IS COMPLETE"

