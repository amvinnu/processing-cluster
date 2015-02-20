#! /bin/bash

cwd=`cd "$(dirname "$0")" && pwd`
$cwd/stop_all.sh

echo "Removing docker images"

sudo docker images | grep -q kafka         && sudo docker rmi kafka
sudo docker images | grep -q spark-client  && sudo docker rmi spark-client
sudo docker images | grep -q spark-worker  && sudo docker rmi spark-worker
sudo docker images | grep -q spark-master  && sudo docker rmi spark-master
sudo docker images | grep -q hadoop-worker && sudo docker rmi hadoop-worker
sudo docker images | grep -q hadoop-master && sudo docker rmi hadoop-master
sudo docker images | grep -q hadoop-base   && sudo docker rmi hadoop-base

sudo docker images | grep -q base          && sudo docker rmi base

echo "Done removing docker images"
