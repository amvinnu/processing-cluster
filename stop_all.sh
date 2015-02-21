#! /bin/bash

cwd=`cd "$(dirname "$0")" && pwd`

source $cwd/env.sh

echo "Stopping any running docker containers"

docker ps    | grep -q kafka-1 && docker stop  kafka-1
docker ps -a | grep -q kafka-1 && docker rm -v kafka-1
docker ps    | grep -q kafka-2 && docker stop  kafka-2
docker ps -a | grep -q kafka-2 && docker rm -v kafka-2

docker ps    | grep -q client-1 && docker stop  client-1
docker ps -a | grep -q client-1 && docker rm -v client-1
docker ps    | grep -q worker-1 && docker stop  worker-1
docker ps -a | grep -q worker-1 && docker rm -v worker-1
docker ps    | grep -q master   && docker stop  master
docker ps -a | grep -q master   && docker rm -v master

docker ps    | grep -q skydock && docker stop  skydock
docker ps -a | grep -q skydock && docker rm -v skydock
docker ps    | grep -q skydns  && docker stop  skydns
docker ps -a | grep -q skydns  && docker rm -v skydns

echo "Done stopping containers"
