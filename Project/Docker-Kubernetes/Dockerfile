FROM redhat/ubi9:latest
MAINTAINER demo@training.com
ENV tomcat_test 123
RUN yum update -y
RUN mkdir -p /opt/tomcat/
WORKDIR /opt/tomcat
RUN curl -O https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.109/bin/apache-tomcat-7.0.109.tar.gz
RUN tar -xvf apache-tomcat-7.0.109.tar.gz
RUN mv apache-tomcat-7.0.109/* /opt/tomcat/
RUN yum -y install java-1.8.0*
RUN java -version
WORKDIR /opt/tomcat/webapps
COPY  ./Project/Docker-Kubernetes/webapp.war /opt/tomcat/webapps/
EXPOSE 8080
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
