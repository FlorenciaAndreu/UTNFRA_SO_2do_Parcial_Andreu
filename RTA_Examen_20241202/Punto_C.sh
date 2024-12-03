#!/bin/bash 
cd .. 
cd UTN-FRA_SO_Examenes/202406/docker

sudo docker build -t florandreu/web1-andreu .
docker login -u florandreu
docker push florandreu/web1-andreu:latest
docker image list
docker run -d -p 8080:80 florandreu/web1-andreu
curl localhost:8080
UTN-FRA_SO_Examenes/202406/docker

