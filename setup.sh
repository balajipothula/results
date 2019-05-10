#!/bin/bash

# Author      : BALAJI POTHULA <balaji.pothula@techie.com>,
# Date        : 09 May 2019,
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
apt install -y openjdk-8-jdk redis-server

cd $HOME                                                                                                         \
  && wget http://mirrors.estointernet.in/apache/maven/maven-3/$MVN_VER/binaries/apache-maven-$MVN_VER-bin.tar.gz \
  && tar xzf apache-maven-$MVN_VER-bin.tar.gz                                                                    \
  && mv apache-maven-$MVN_VER $HOME/maven                                                                        \
  && ln -s $HOME/maven/bin/mvn /usr/bin/mvn                                                                      \
  && rm apache-maven-$MVN_VER-bin.tar.gz

# creating a deployable JAR file.
mvn -f $HOME/genfakedata/pom.xml clean package

# running fake data generator JAR file.
# generating data and inserting into redis db. 
java -jar $HOME/genfakedata.jar
