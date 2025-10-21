#!/bin/bash
#------------Jfrog slave node setup for redhat os-------------------
# java
# wget
# jfrog
# configrations

sudo yum update -y

# install java 21
 sudo yum install java-21-openjdk -y

#install wget
sudo yum install wget -y

# jfrog installation
cd /opt
sudo wget https://releases.jfrog.io/artifactory/bintray-artifactory/org/artifactory/oss/jfrog-artifactory-oss/7.77.7/jfrog-artifactory-oss-7.77.7-linux.tar.gz
sudo tar -xvf jfrog-artifactory-oss-7.77.7-linux.tar.gz
sudo mv artifactory-oss-7.77.7 jfrog
sudo rm -rf jfrog-artifactory-oss-7.77.7-linux.tar.gz

# create jfrog user and give root permission
sudo useradd jfrog
sudo echo "jfrog:jfrog" | sudo chpasswd

sudo usermod -aG root jfrog

# change ownership to jfrog user
sudo ls -ld  /opt/jfrog
sudo chown -R jfrog:jfrog /opt/jfrog
sudo ls -ld  /opt/jfrog

# run jfrog service at boot
#-----------
sudo tee /etc/systemd/system/jfrog.service > /dev/null <<EOF
[Unit]
Description=jfrog service
After=network.target
[Service]
Type=forking
LimitNOFILE=65536
User=jfrog
Group=jfrog
ExecStart=/opt/jfrog/app/bin/artifactoryctl start
ExecStop=/opt/jfrog/app/bin/artifactoryctl stop
User=jfrog
Restart=on-abort
[Install]
WantedBy=multi-user.target
EOF
#---------------
sudo systemctl enable jfrog.service
sudo systemctl start jfrog.service


echo "jfrog machine setup is complete all the requirments are installed"







