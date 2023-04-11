#!/bin/bash
docker volume inspect nexus-data >/dev/null 2>&1 || docker volume create --name nexus-data
docker network inspect intranet >/dev/null 2>&1 ||     docker network create intranet
docker inspect nexus >/dev/null 2>&1 || docker run -d -p 8081:8081 -p 8123:8123 -p 8083:8083 --name nexus -v nexus-data:/nexus-data --restart unless-stopped --network intranet sonatype/nexus3
