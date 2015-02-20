#! /bin/bash

echo "Stopping any running docker containers"

sudo docker ps    | grep -q kafka-1 && sudo docker stop  kafka-1
sudo docker ps -a | grep -q kafka-1 && sudo docker rm -v kafka-1
sudo docker ps    | grep -q kafka-2 && sudo docker stop  kafka-2
sudo docker ps -a | grep -q kafka-2 && sudo docker rm -v kafka-2

sudo docker ps    | grep -q spark-client && sudo docker stop  spark-client
sudo docker ps -a | grep -q spark-client && sudo docker rm -v spark-client
sudo docker ps    | grep -q spark-worker && sudo docker stop  spark-worker
sudo docker ps -a | grep -q spark-worker && sudo docker rm -v spark-worker
sudo docker ps    | grep -q spark-master && sudo docker stop spark-master
sudo docker ps -a | grep -q spark-master && sudo docker rm -v spark-master

sudo docker ps    | grep -q skydock && sudo docker stop skydock
sudo docker ps -a | grep -q skydock && sudo docker rm -v skydock
sudo docker ps    | grep -q skydns && sudo docker stop skydns
sudo docker ps -a | grep -q skydns && sudo docker rm -v skydns

echo "Done stopping containers"
