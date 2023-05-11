############################################################
FROM centos:8
USER root
RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
RUN yum update -y

RUN yum install git java-1.8.0-openjdk-devel.x86_64 wget unzip maven -y
RUN cd /mnt/ && git clone https://github.com/Er-Mahesh-Patil/game-of-life.git && cd game-of-life/ && mvn clean install -DskipTests=true
RUN cd /mnt/ && wget  https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.74/bin/apache-tomcat-9.0.74.zip && unzip apache-tomcat-9.0.74.zip
RUN cp -r /mnt/game-of-life/gameoflife-web/target/gameoflife.war /mnt/apache-tomcat-9.0.74/webapps/ && rm -rf apache-tomcat-9.0.74.zip
RUN chmod 744 /mnt/apache-tomcat-9.0.74/bin/catalina.sh && chmod 744 /mnt/apache-tomcat-9.0.74/bin/startup.sh && sh /mnt/apache-tomcat-9.0.74/bin/startup.sh
EXPOSE 8080/tcp
############################################################
