#!/usr/bin/env bash

# package=(firewalld python3-pip python3-venv zsh)
package=(firewalld zsh)

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
