#! /bin/bash

cwd=`cd "$(dirname "$0")" && pwd`

source $cwd/env.sh

docker images | grep -q skydns  || docker pull crosbymichael/skydns
docker images | grep -q skydock || docker pull crosbymichael/skydock

docker images | grep -q ${NAMESPACE}spark-master  || docker pull ${NAMESPACE}spark-master
docker images | grep -q ${NAMESPACE}spark-worker  || docker pull ${NAMESPACE}spark-worker
docker images | grep -q ${NAMESPACE}spark-client  || docker pull ${NAMESPACE}spark-client

docker images | grep -q ${NAMESPACE}kafka         || docker pull ${NAMESPACE}kafka

