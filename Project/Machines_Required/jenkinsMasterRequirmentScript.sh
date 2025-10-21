#!/bin/bash
#------------jenkins master node setup for redhat os-------------------
# java21
# wget
# jenkins
# git

sudo yum update -y

#install java21
sudo yum install java-21-openjdk -y

# install wget
sudo yum install wget -y

#jenkins installation

sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade -y
# Add required dependencies for the jenkins package
sudo yum install fontconfig java-21-openjdk -y
sudo yum install jenkins -y
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins

#install git
sudo yum install git -y
echo "Jenkins Master Node Requirments installed and Jenkins is up"
