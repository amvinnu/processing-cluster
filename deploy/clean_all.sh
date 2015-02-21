#! /bin/bash

cwd=`cd "$(dirname "$0")" && pwd`

source $cwd/env.sh
$cwd/stop_all.sh

echo "Removing docker images"

docker images | grep -q ${NAMESPACE}kafka         && docker rmi ${NAMESPACE}kafka

docker images | grep -q ${NAMESPACE}spark-client  && docker rmi ${NAMESPACE}spark-client
docker images | grep -q ${NAMESPACE}spark-worker  && docker rmi ${NAMESPACE}spark-worker
docker images | grep -q ${NAMESPACE}spark-master  && docker rmi ${NAMESPACE}spark-master

docker images | grep -q ${NAMESPACE}hadoop-worker && docker rmi ${NAMESPACE}hadoop-worker
docker images | grep -q ${NAMESPACE}hadoop-master && docker rmi ${NAMESPACE}hadoop-master
docker images | grep -q ${NAMESPACE}hadoop-base   && docker rmi ${NAMESPACE}hadoop-base

docker images | grep -q ${NAMESPACE}base          && docker rmi ${NAMESPACE}base

echo "Done removing docker images"
