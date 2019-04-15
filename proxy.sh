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
        port=3333
        echo "export proxyPort=3333" >>~/.profile
        ufw allow 3333/tcp
else
        sed -i -e "s/3333/${port}/g" /etc/squid/squid.conf
        echo "export proxyPort=$port" >>~/.profile
        ufw allow ${port}/tcp
fi

echo "export proxyAddress=$(hostname --all-ip-addresses)" >>~/.profile
echo "export proxyLogin=$username" >>~/.profile
echo "export proxyPassword=$password ">>~/.profile

echo "Hostname: ${red} $(hostname --all-ip-addresses) ${reset}"
echo "Port: ${red} ${port} ${reset}"
echo "Username: ${red} $username ${reset}"
echo "Password: ${red} $password ${reset}"
service squid start
