#!/bin/bash
#-------------------sonarqube machine with Tomcat setup for redhat os-----------------------
# java21
# wget
# zip
# sonarQube

sudo yum update -y

# install java 21
 sudo yum install java-21-openjdk -y

# install wget
sudo yum install wget -y

# install zip
sudo yum install zip -y

# install sonarQube
cd /opt 
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-25.4.0.105899.zip
sudo unzip sonarqube-25.4.0.105899.zip
sudo mv sonarqube-25.4.0.105899 sonarqube
sudo rm -rf sonarqube-25.4.0.105899.zip

# create sonar user
sudo useradd sonar
echo "sonar:sonar" | sudo chpasswd

# give sudo permission
sudo usermod -aG  root sonar
# change wonership
ls -ld  /opt/sonarqube
chown -R sonar:sonar /opt/sonarqube
ls -ld  /opt/sonarqube

# start the sonarqube service at boot
#-----------
sudo tee /etc/systemd/system/sonar.service > /dev/null <<EOF
[Unit]
Description=sonar service
After=network.target
[Service]
Type=forking
LimitNOFILE=65536
User=sonar
Group=sonar
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
Restart=on-abort
[Install]
WantedBy=multi-user.target
EOF
#---------------

sudo systemctl daemon-reload
sudo systemctl enable sonar.service
sudo systemctl start sonar.service

echo "sonar machine is ready all the requirments are installed"

# Now tomcat installtion
# java21 and and wget we already installed which is prerequisit

# creating tomcat user
useradd tomcat
sudo echo "tomcat:tomcat" | sudo chpasswd

# giving root permision
sudo usermod -aG root tomcat

# tomcat installation
sudo cd /opt
sudo wget https://archive.apache.org/dist/tomcat/tomcat-11/v11.0.0/bin/apache-tomcat-11.0.0.tar.gz
sudo tar -xzf apache-tomcat-11.0.0.tar.gz
sudo mv apache-tomcat-11.0.0 tomcat
sudo rm -rf apache-tomcat-11.0.0.tar.gz

# change owner ship from root to tomcat user
ls -ld  /opt/tomcat
chown -R tomcat:tomcat /opt/tomcat
ls -ld  /opt/tomcat

# start the tomcat service at boot
#-----------
sudo tee /etc/systemd/system/tomcat.service > /dev/null <<EOF
[Unit]
Description=Apache Tomcat
After=network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/java-21-openjdk 
Environment=CATALINA_PID=/opt/tomcat/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment='CATALINA_OPTS=-Xmx1024M -server'

WorkingDirectory=/opt/tomcat

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

User=tomcat
Group=tomcat
UMask=0007
RestartSec=15
Restart=always

[Install]
WantedBy=multi-user.target
EOF
#---------------

sudo systemctl daemon-reload
sudo systemctl enable tomcat.service
sudo systemctl start tomcat.service

# configration for tomcat
#---------------------------------------------------------------------------------------------
sudo tee /opt/tomcat/conf/tomcat-users.xml > /dev/null <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<tomcat-users xmlns="http://tomcat.apache.org/xml"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"
              version="1.0">
<!--
  By default, no user is included in the "manager-gui" role required
  to operate the "/manager/html" web application.  If you wish to use this app,
  you must define such a user - the username and password are arbitrary.

  Built-in Tomcat manager roles:
    - manager-gui    - allows access to the HTML GUI and the status pages
    - manager-script - allows access to the HTTP API and the status pages
    - manager-jmx    - allows access to the JMX proxy and the status pages
    - manager-status - allows access to the status pages only

  The users below are wrapped in a comment and are therefore ignored. If you
  wish to configure one or more of these users for use with the manager web
  application, do not forget to remove the <!.. ..> that surrounds them. You
  will also need to set the passwords to something appropriate.
-->
<!--
  <user username="admin" password="<must-be-changed>" roles="manager-gui"/>
  <user username="robot" password="<must-be-changed>" roles="manager-script"/>
-->
<!--
  The sample user and role entries below are intended for use with the
  examples web application. They are wrapped in a comment and thus are ignored
  when reading this file. If you wish to configure these users for use with the
  examples web application, do not forget to remove the <!.. ..> that surrounds
  them. You will also need to set the passwords to something appropriate.
-->
<!--
  <role rolename="tomcat"/>
  <role rolename="role1"/>
  <user username="tomcat" password="<must-be-changed>" roles="tomcat"/>
  <user username="both" password="<must-be-changed>" roles="tomcat,role1"/>
  <user username="role1" password="<must-be-changed>" roles="role1"/>
-->
<role rolename="admin-gui"/>
<role rolename="manager-gui"/>
<role rolename="manager-script"/>
<role rolename="manager-jmx"/>
<role rolename="manager-status"/>
<user username="admin" password="admin" roles="manager-gui,manager-script,manager-jmx,manager-status,admin-gui"/>
</tomcat-users>
EOF

#--------------------------------------------------------------------------------------------------------------------------------

sudo tee /opt/tomcat/webapps/manager/META-INF/context.xml > /dev/null <<EOF

 <?xml version="1.0" encoding="UTF-8"?>
<!--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<Context antiResourceLocking="false" privileged="true" ignoreAnnotations="true">
  <CookieProcessor className="org.apache.tomcat.util.http.Rfc6265CookieProcessor"
                   sameSiteCookies="strict" />
<!--  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" /> -->
  <Manager sessionAttributeValueClassNameFilter="java\.lang\.(?:Boolean|Integer|Long|Number|String)|org\.apache\.catalina\.filters\.CsrfPreventionFilter\$LruCache(?:\$1)?|java\.util\.(?:Linked)?HashMap"/>
</Context>
EOF
#----------------------------------------------------------------------------------------------------------------------------------------


sudo tee /opt/tomcat/webapps/host-manager/META-INF/context.xml > /dev/null <<EOF
 <?xml version="1.0" encoding="UTF-8"?>
<!--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<Context antiResourceLocking="false" privileged="true" ignoreAnnotations="true">
  <CookieProcessor className="org.apache.tomcat.util.http.Rfc6265CookieProcessor"
                   sameSiteCookies="strict" />
<!--  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" /> -->
  <Manager sessionAttributeValueClassNameFilter="java\.lang\.(?:Boolean|Integer|Long|Number|String)|org\.apache\.catalina\.filters\.CsrfPreventionFilter\$LruCache(?:\$1)?|java\.util\.(?:Linked)?HashMap"/>
</Context>
EOF
#--------------------------------------------------------------------------------------------------------------------------------------------

# restart tomcat server

sudo systemctl restart tomcat.service


echo "tomcat setup completed"













