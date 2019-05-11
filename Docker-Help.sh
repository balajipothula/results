# tomcat-8.5.40
## alpine linux image with openjdk8-jre, tomcat-native, sqlite, redis.
### Author: BALAJI POTHULA <*balaji.pothula@techie.com*>

#### Cloning tomcat8 from GitHub.
git clone https://github.com/balajipothula/tomcat-8.5.40-redis-4.0.11.git

##### Installing "docker" on Ubuntu OS and
##### setting "tomcat" server with "web application".
sudo sh $HOME/tomcat-8.5.40-redis-4.0.11/setup.sh

##### Adding current user to "docker" group.
##### Running docker as non-sudoer.
##### Note: Reboot required.
##### After Reboot sudo not required by "docker".
sudo usermod -a -G docker $USER

##### Pulling image from Docker Hub.
sudo docker pull balajipothula/tomcat:8.5.40

##### Creating or Building image from Dockerfile.
##### username/repo:tag.
sudo docker build -t balajipothula/tomcat:8.5.40 .

##### Saving docker image offline into local machine.
sudo docker save -o tomcat-8.5.40.docker balajipothula/tomcat:8.5.40

##### Loading offline docker image into machine.
sudo docker load -i tomcat-8.5.40.docker

##### Displaying docker images.
sudo docker images

##### Displaying docker running containers.
sudo docker ps

##### Displaying docker all containers.
sudo docker ps -a

##### Running docker image with volume(-v) stdin(-i) daemon(-d) with port(-p) 8080 for Tomcat.
##### (It will create a volume inside the container)
sudo docker run --name tomcat -d -i -p 8080:8080 --privileged -v $HOME/tomcat-8.5.40-redis-4.0.11/webapp:/webapp balajipothula/tomcat:8.5.40 sh

##### Executing docker container by name with stdin(-i), startup  tomcat server.
sudo docker exec -i tomcat /webapp/tomcat/bin/startup.sh

##### Executing docker container by name with stdin(-i), shutdown tomcat server.
sudo docker exec -i tomcat /webapp/tomcat/bin/shutdown.sh

##### Executing docker container by name with stdin(-i), startup  redis server.
sudo docker exec -i tomcat redis-server /webapp/redis/conf/redis.conf

##### Login into docker container.
sudo docker exec -i -t tomcat sh

##### Starting docker container with name.
sudo docker start tomcat

##### Stoping  docker container with name.
sudo docker stop tomcat

##### Removing docker container with name.
sudo docker rm tomcat

##### Removing docker image with username/repo:tag.
sudo docker rmi balajipothula/tomcat:8.5.40
