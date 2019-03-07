if !(grep "1" /root/toggle)
then
	apt update -y && apt upgrade -y
	cp resourses/interfaces /etc/network/interfaces
	echo "1" > toggle
	reboot
	exit
fi
apt install sudo openssh-server ufw portsentry nginx mailutils
usermod -aG sudo rojer
cp resourses/before.rules /etc/ufw/
ufw enable
ufw logging on
ufw allow 4444
ufw allow 80
ufw allow 443
ufw allow 22
ufw reload
cp resourses/portsentry.conf /etc/portsentry/
service portsentry restart
mkdir /root/scripts
cp resourses/upd_script.sh /root/scripts
cp resourses/cron_checker.sh /root/scripts
cp resourses/aliases /etc/aliases
crontab resourses/crontab.dat
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
cp resourses/self-signed.conf /etc/nginx/snippets/ssl-params.conf
cp resourses/default /etc/nginx/sites-enabled/default