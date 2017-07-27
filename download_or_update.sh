OS=$(python -c 'import platform ; print platform.dist()[0]')
echo -e "123\n123" | sudo passwd root; # temporarily changing password
if [[ "$OS" == "Ubuntu" ]]; then
	echo -e "123\n123" | sudo passwd root;
	wget https://raw.githubusercontent.com/kaustav1996/UNIX/master/main.sh;
	sudo bash main.sh;
elif [[ "$OS" == "CentOS Linux" ]]; then
	sudo yum -y install wget;
	wget https://raw.githubusercontent.com/kaustav1996/UNIX/master/main.sh;
	sudo bash main.sh;
else
	echo "OS NOT SUPPORTED YET!!"
fi
