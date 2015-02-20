#! /bin/bash

./clean_all.sh

sudo docker images | grep -q skydns || sudo docker pull crosbymichael/skydns
sudo docker images | grep -q skydock || sudo docker pull crosbymichael/skydock

sudo docker build -t base base

sudo docker build -t hadoop-base hadoop/hadoop-base
sudo docker build -t hadoop-worker hadoop/hadoop-worker
sudo docker build -t hadoop-master hadoop/hadoop-master

sudo docker build -t spark-master spark/spark-master
sudo docker build -t spark-worker spark/spark-worker
sudo docker build -t spark-client spark/spark-client

sudo docker build -t kafka kafka
