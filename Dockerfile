FROM ubuntu:latest

RUN apt-get update
#RUN apt-get install python-software-properties

#RUN apt-add-repository -y ppa:ubuntugis/ppa
#RUN apt-add-repository -y ppa:georepublic/pgrouting

RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install openjdk-8-jdk wget

RUN apt-get update -y && apt-get install maven -y

RUN apt-get -y install locate
RUN updatedb

# install Tomcat
RUN wget http://mirrors.ibiblio.org/apache/tomcat/tomcat-8/v8.5.32/bin/apache-tomcat-8.5.32.tar.gz
RUN tar xvzf apache-tomcat-8.5.32.tar.gz
RUN mv apache-tomcat-8.5.32 /opt/tomcat

COPY tomcat-users.xml /opt/tomcat/conf/ 
COPY context.xml /opt/tomcat/webapps/manager/META-INF/

RUN rm apache-tomcat-8.5.32.tar.gz

# Maintainer 
MAINTAINER "ajoy.sinha@live.com" 


RUN export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
RUN export CATALINA_HOME=/opt/tomcat
RUN export MAVEN_HOME=/usr/share/maven
RUN export PATH=$PATH:$CATALINA_HOME:$JAVA_HOME:$MAVEN_HOME

RUN . ~/.bashrc

RUN mkdir application

COPY . /application
WORKDIR /application
RUN mvn clean install

RUN ls
RUN mv /application/target/DockerWebAppFull.war /opt/tomcat/webapps/

# RUN tomcat server
WORKDIR /opt/tomcat
RUN ["chown", "-R", "daemon", "."]

EXPOSE 8080

CMD /opt/tomcat/bin/catalina.sh run

