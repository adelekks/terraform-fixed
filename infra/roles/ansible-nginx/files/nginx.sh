#!/bin/bash
docker network inspect intranet >/dev/null 2>&1 ||     docker network create intranet
docker ps -qa --filter "name=nginx" | grep -q . && docker stop nginx && docker rm -fv nginx
docker images -qa --filter=reference="nginx-img" | grep -q . && docker rmi nginx-img
docker build -t nginx-img .
docker run -d -p 80:80 -p 443:443 --name nginx --restart unless-stopped --network intranet nginx-img 
