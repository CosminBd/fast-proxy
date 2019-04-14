#!/bin/bash
red=`tput setaf 1`
reset=`tput sgr0`
apt-get install -y  squid apache2-utils
cp /etc/squid/squid.conf /etc/squid/squid.conf.org
cp squid.conf /etc/squid/squid.conf
password=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '')
echo "${red}Your password is: $password ${reset}"
echo "${red}Enter proxy username${reset}"
read username
echo "${red}Enter proxy port (default is 3333) ${reset}"
read port
echo "$password"|htpasswd -c -i  /etc/squid/passwd $username 
cat /etc/squid/passwd
service squid stop

if [ -z "$port" ]
then
	$port=3333
	service squid start
	export proxyPort=3333
	ufw allow 3333/tcp
else
	sed -i -e "s/3333/${port}/g" /etc/squid/squid.conf
	service squid start
	export proxyPort=$port
	ufw allow ${port}/tcp
fi

export proxyAddress=$(hostname --all-ip-addresses)
export proxyLogin=$username
export proxyPassword=$password

echo "Hostname: ${red} $(hostname --all-ip-addresses) ${reset}"
echo "Port: ${red} ${port} ${reset}"
echo "Username: ${red} $username ${reset}"
echo "Password: ${red} $password ${reset}"

