#!/usr/bin/env bash

# package=(firewalld python3-pip python3-venv zsh)
package=(firewalld zsh)
# email=wilk85@gmail.com

# # update packages
apt update -y -qq

# check if firewalld is installed
check_package_installed() {
    apt-cache policy ${package} | grep -i installed | cut -d ':' -f 1 --complement | tr -d ' ' 
}

# packages installation
if [[ $(check_package_installed) == "(none)" ]]; then
    apt install ${package} -y
    echo '+ installed' ${package} 'version:' $(check_package_installed)
else
    echo '+' ${package} 'already installed with version:' $(check_package_installed)
fi

#starting firewalld
systemctl enable firewalld
systemctl start firewalld
systemctl status firewalld | grep Active

# setting up ports
firewall-cmd --list-ports
# firewall-cmd --add-port 10011/tcp --add-port 30033/tcp --add-port 9987/udp --permanent # teamspeak server
firewall-cmd --add-port 3979/udp --permanent # openttd server
firewall-cmd --reload
firewall-cmd --list-ports

# setting up docker-compose directories
# mkdir vol

# echo "version: '3.9'
# services:
#   teamspeak:
#     image: teamspeak
#     restart: always
#     ports:
#       - 9987:9987/udp
#       - 10011:10011
#       - 30033:30033
#     environment:
#       TS3SERVER_LICENSE: accept
#     volumes:
#       - '/var/run/docker.sock:/var/run/docker.sock'
#       - './vol:/var/ts3server/logs'" > docker-compose.yml


# install docker engine
# apt-get remove docker docker-engine docker.io containerd runc -y
# apt-get install ca-certificates curl gnupg lsb-release -y
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
# echo \
#   "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
#   $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# apt-get install docker-ce docker-ce-cli containerd.io -y
# docker --version

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


# install docker compose
# curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# chmod +x /usr/local/bin/docker-compose
# ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
# docker-compose --version

# start docker compose teamspeak image
# docker-compose up -d

# send teamspeak token through email
# sleep 30
# apt install sendemail -y
# sendemail -f teamspeak3@oci.com -t $email -m "Teamspeak 3 admin token" -a vol/ts3*.*_1.log