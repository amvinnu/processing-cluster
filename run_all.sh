#! /bin/bash

cwd=`cd "$(dirname "$0")" && pwd`

source $cwd/env.sh
$cwd/stop_all.sh

# is typically 172.17.42.1
DOCKER_BRIDGE_ADDR=$(ifconfig | grep -A1 docker0 | grep "inet addr" | awk -F':' '{print $2}' | awk '{print $1}')

echo "Starting skydns"
docker run -d -p $DOCKER_BRIDGE_ADDR:53:53/udp --name skydns crosbymichael/skydns -nameserver 8.8.8.8:53 -domain $DOMAIN

echo "Starting skydock"
docker run -d -v /var/run/docker.sock:/docker.sock --name skydock crosbymichael/skydock -ttl 30 -environment $ENVRN -s /docker.sock -domain $DOMAIN -name skydns

echo "Starting Master ...."

docker run -h $MASTER -d --name master --dns $DOCKER_BRIDGE_ADDR -e MASTER_HOST=$MASTER ${NAMESPACE}spark-master

echo "Waiting for Master to come up ...."

# TODO replace sleep by checking docker logs for Spark Master UI up message
sleep 30

echo "Starting Worker ...."

docker run -h $WORKER1 -d --name worker-1 --dns $DOCKER_BRIDGE_ADDR -e MASTER_HOST=$MASTER ${NAMESPACE}spark-worker

echo "Waiting for Worker to come up ...."

# TODO replace sleep by checking docker logs for Spark Worker UI up message
sleep 30

echo "Starting Client ...."

docker run -h $CLIENT1 -d --name client-1 --dns $DOCKER_BRIDGE_ADDR -e MASTER_HOST=$MASTER ${NAMESPACE}spark-client

echo "Waiting for Client to come up ...."

# TODO replace sleep by checking docker logs for Oozie startup message
sleep 30

echo "Starting Kafka-1 ...."

docker run -h $KAFKA1 -d --name kafka-1 --dns $DOCKER_BRIDGE_ADDR -e KAFKA_ZOOKEEPER_CONNECT=$MASTER:2181 -e KAFKA_BROKER_ID=1 -e KAFKA_HOST_NAME=KAFKA1 ${NAMESPACE}kafka

echo "Waiting for Kafka-1 to come up ...."

# TODO replace sleep by checking docker logs for Kafka startup message
sleep 10

echo "Starting Kafka-2 ...."

docker run -h $KAFKA2 -d --name kafka-2 --dns $DOCKER_BRIDGE_ADDR -e KAFKA_ZOOKEEPER_CONNECT=$MASTER:2181 -e KAFKA_BROKER_ID=2 -e KAFKA_HOST_NAME=KAFKA2 ${NAMESPACE}kafka

echo "Waiting for Kafka-2 to come up ...."

# TODO replace sleep by checking docker logs for Kafka startup message
sleep 10

echo "Configuring your /etc/hosts ...."

function addOrReplaceHost() {
  local container_name="$1"
  local fqhn="$2"

  local ip=`docker inspect $container_name | grep -i ipaddress | awk -F'"' '{print $4}'`

  grep -q $container_name /etc/hosts && sed -i "s/^.* $container_name .*$/$ip $container_name $fqhn/" /etc/hosts || echo $ip $container_name $fqhn >> /etc/hosts
}

addOrReplaceHost master   $MASTER
addOrReplaceHost worker-1 $WORKER1
addOrReplaceHost client-1 $CLIENT1
addOrReplaceHost kafka-1  $KAFKA1
addOrReplaceHost kafka-2  $KAFKA2

echo "Done"

