#!/bin/bash

# Author      : BALAJI POTHULA <balaji.pothula@techie.com>,
# Date        : 10 May 2019,
# Description : Installing openjdk, tomcat, redis and maven on Ubuntu.

# Note: Please run this script with sudo privilage.

# setting maven version.
readonly MVN_VER=3.6.1

# updating packages index.
apt update

# upgrading packages.
DEBIAN_FRONTEND=noninteractive apt -y upgrade

# installing openjdk8.
# maven3.3+ require jdk1.7+
apt -y install openjdk-8-jdk

# installing packages to allow apt to use repository over https.
apt -y install apt-transport-https \
               ca-certificates     \
               curl                \
               software-properties-common

# adding docker official gpg key.
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# setting up the stable docker repository.
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# updating apt package index.
apt update

# installing latest version of docker ce.
apt -y install docker-ce docker-ce-cli containerd.io

# downloading and setting maven
cd $HOME                                                                                                         \
  && wget http://mirrors.estointernet.in/apache/maven/maven-3/$MVN_VER/binaries/apache-maven-$MVN_VER-bin.tar.gz \
  && tar xzf apache-maven-$MVN_VER-bin.tar.gz                                                                    \
  && mv apache-maven-$MVN_VER $HOME/maven                                                                        \
  && ln -s $HOME/maven/bin/mvn /usr/bin/mvn                                                                      \
  && rm apache-maven-$MVN_VER-bin.tar.gz

# extracting webapp.tar.gz
tar xzf $HOME/results/webapp.tar.gz -C $HOME/results

# creating a deployable JAR file.
mvn -f $HOME/results/pom.xml clean install

# pulling tomcat:8.5.40 image from docker hub.
docker pull balajipothula/tomcat:8.5.40

# running docker container with name(--name) "tomcat" as daemon(-d),
# stdin(-i) with volume(-v) "webapp" on port(-p) "8080".
docker run --name results -d -i -p 8080:8080 --privileged -v $HOME/results/webapp:/webapp balajipothula/tomcat:8.5.40 sh

# executing docker container by name with stdin(-i), starting tomcat server.
docker exec -i results /webapp/tomcat/bin/startup.sh

# executing docker container by name with stdin(-i), starting redis server.
docker exec -i results redis-server /webapp/redis/conf/redis.conf
