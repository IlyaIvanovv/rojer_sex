if !(grep "1" /root/toggle)
then
	echo "1" > toggle
	apt install unzip -y 
	wget https://github.com/IlyaIvanovv/rojer_sex/archive/master.zip
	mkdir /root/rs
	unzip master.zip
	cp -r rojer_sex-master/* /root/rs/
	cd /root/rs
	apt update -y && apt upgrade -y
	echo "~~~~~~~~~~~~~~~~~~NETWORK CONFIGURE~~~~~~~~~~~~~~~~~~~~~~~~~~"
	cp resourses/interfaces /etc/network/interfaces
	reboot
	exit
fi
cd /root/rs
apt install sudo openssh-server ufw portsentry nginx mailutils
echo "~~~~~~~~~~~~~~~~~~SUDO CONFIGURE~~~~~~~~~~~~~~~~~~~~~~~~~~"
usermod -aG sudo rojer
echo "~~~~~~~~~~~~~~~~~~SSH CONFIGURE~~~~~~~~~~~~~~~~~~~~~~~~~~"
cp resourses/sshd_config /etc/ssh/sshd_config
echo "~~~~~~~~~~~~~~~~~~FIREWALL CONFIGURE~~~~~~~~~~~~~~~~~~~~~~~~~~"
cp resourses/before.rules /etc/ufw/
ufw enable
ufw logging on
ufw allow 4444
ufw allow 80
ufw allow 443
ufw allow 22
ufw reload
echo "~~~~~~~~~~~~~~~~~~PORTSENTRY CONFIGURE~~~~~~~~~~~~~~~~~~~~~~~~~~"
cp resourses/portsentry.conf /etc/portsentry/
service portsentry restart
mkdir /root/scripts
echo "~~~~~~~~~~~~~~~~~~CRONTAB CONFIGURE~~~~~~~~~~~~~~~~~~~~~~~~~~"
cp resourses/upd_script.sh /root/scripts
cp resourses/cron_checker.sh /root/scripts
cp resourses/aliases /etc/aliases
crontab resourses/crontab.dat
echo "~~~~~~~~~~~~~~~~~~SSL CONFIGURE~~~~~~~~~~~~~~~~~~~~~~~~~~"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
cp resourses/self-signed.conf /etc/nginx/snippets/ssl-params.conf
cp resourses/default /etc/nginx/sites-enabled/default