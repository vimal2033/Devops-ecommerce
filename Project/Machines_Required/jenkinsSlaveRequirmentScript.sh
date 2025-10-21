#!/bin/bash

#------------jenkins slave node setup for redhat os-------------------
# java21
# git
# wget
# maven
# create jenkins user and give permissions
# PermitRootLogin and PasswordAuthentication
# create ssh key for jenkins user

sudo yum update -y

# install java 21
 sudo yum install java-21-openjdk -y

# install github
sudo yum install git -y

#install wget
sudo yum install wget -y

# install maven
#-----------------------------------------------------------
cd /opt
wget https://dlcdn.apache.org/maven/maven-3/3.9.11/binaries/apache-maven-3.9.11-bin.tar.gz
tar -xvf apache-maven-3.9.11-bin.tar.gz
mv apache-maven-3.9.11 maven
rm -rf apache-maven-3.9.11-bin.tar.gz
# adding in path to access from anywhare
sudo tee /etc/profile.d/maven.sh > /dev/null <<EOF
export MAVEN_HOME=/opt/maven
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk
export PATH=\${JAVA_HOME}/bin:\${MAVEN_HOME}/bin:\${PATH}
EOF

sudo chmod +x /etc/profile.d/maven.sh
source /etc/profile.d/maven.sh
mvn --version
#-----------------------------------------------------------
#create jenkins user
sudo useradd -m -d /var/lib/jenkins jenkins
sudo echo "jenkins:jenkins" | sudo chpasswd

# giving nesscery permissions
# sudo visudo
sudo usermod -aG wheel,root jenkins
sudo echo "%wheel ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/wheel_nopasswd
sudo chmod 440 /etc/sudoers.d/wheel_nopasswd


sudo echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config.d/01-permitrootlogin.conf
sudo echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config.d/01-permitrootlogin.conf

sudo systemctl restart sshd

# running command as jenkins user
# exit
# sudo su - Jenkins

# ssh-keygen -t rsa
# cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys

sudo -u jenkins bash -c 'ssh-keygen -t rsa -f /var/lib/jenkins/.ssh/id_rsa -N ""; cat /var/lib/jenkins/.ssh/id_rsa.pub >> /var/lib/jenkins/.ssh/authorized_keys'
sudo chown -R jenkins:jenkins /var/lib/jenkins/.ssh
sudo chmod 700 /var/lib/jenkins/.ssh
sudo chmod 600 /var/lib/jenkins/.ssh/authorized_keys

echo "Jenkins slave machine is ready all the requirments are installed"


                                                                                                      