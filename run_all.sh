#! /bin/bash

DOMAIN=test.corp
ENVRN=dev
MASTER=spark-master.$ENVRN.$DOMAIN
WORKER=spark-worker.$ENVRN.$DOMAIN
CLIENT=spark-client.$ENVRN.$DOMAIN
KAFKA1=kafka-1.kafka.$ENVRN.$DOMAIN
KAFKA2=kafka-2.kafka.$ENVRN.$DOMAIN

cwd=`cd "$(dirname "$0")" && pwd`
$cwd/stop_all.sh

# is typically 172.17.42.1
DOCKER_BRIDGE_ADDR=$(sudo ifconfig | grep -A1 docker0 | grep "inet addr" | awk -F':' '{print $2}' | awk '{print $1}')

echo "Starting skydns"
sudo docker run -d -p $DOCKER_BRIDGE_ADDR:53:53/udp --name skydns crosbymichael/skydns -nameserver 8.8.8.8:53 -domain $DOMAIN

echo "Starting skydock"
sudo docker run -d -v /var/run/docker.sock:/docker.sock --name skydock crosbymichael/skydock -ttl 30 -environment $ENVRN -s /docker.sock -domain $DOMAIN -name skydns

echo "Starting Master ...."

sudo docker run -h $MASTER -d --name spark-master --dns $DOCKER_BRIDGE_ADDR -e MASTER_HOST=$MASTER spark-master

echo "Waiting for Master to come up ...."

# TODO replace sleep by checking docker logs for Spark Master UI up message
sleep 30

echo "Starting Worker ...."

sudo docker run -h $WORKER -d --name spark-worker --dns $DOCKER_BRIDGE_ADDR -e MASTER_HOST=$MASTER spark-worker

echo "Waiting for Worker to come up ...."

# TODO replace sleep by checking docker logs for Spark Worker UI up message
sleep 30

echo "Starting Client ...."

sudo docker run -h $CLIENT -d --name spark-client --dns $DOCKER_BRIDGE_ADDR -e MASTER_HOST=$MASTER spark-client

echo "Waiting for Client to come up ...."

# TODO replace sleep by checking docker logs for Oozie startup message
sleep 30

echo "Starting Kafka-1 ...."

sudo docker run -h $KAFKA1 -d --name kafka-1 --dns $DOCKER_BRIDGE_ADDR -e KAFKA_ZOOKEEPER_CONNECT=$MASTER:2181 -e KAFKA_BROKER_ID=1 -e KAFKA_HOST_NAME=KAFKA1 kafka

echo "Waiting for Kafka-1 to come up ...."

# TODO replace sleep by checking docker logs for Kafka startup message
sleep 10

echo "Starting Kafka-2 ...."

sudo docker run -h $KAFKA2 -d --name kafka-2 --dns $DOCKER_BRIDGE_ADDR -e KAFKA_ZOOKEEPER_CONNECT=$MASTER:2181 -e KAFKA_BROKER_ID=2 -e KAFKA_HOST_NAME=KAFKA2 kafka

echo "Waiting for Kafka-2 to come up ...."

# TODO replace sleep by checking docker logs for Kafka startup message
sleep 10

echo "Configuring your /etc/hosts ...."

sudo MASTER=$MASTER WORKER=$WORKER CLIENT=$CLIENT KAFKA1=$KAFKA1 KAFKA2=$KAFKA2 bash <<"EOF"
MASTER_IP=`sudo docker inspect spark-master | grep -i ipaddress | awk -F'"' '{print $4}'`
WORKER_IP=`sudo docker inspect spark-worker | grep -i ipaddress | awk -F'"' '{print $4}'`
CLIENT_IP=`sudo docker inspect spark-client | grep -i ipaddress | awk -F'"' '{print $4}'`
KAFKA1_IP=`sudo docker inspect kafka-1 | grep -i ipaddress | awk -F'"' '{print $4}'`
KAFKA2_IP=`sudo docker inspect kafka-2 | grep -i ipaddress | awk -F'"' '{print $4}'`

grep -q spark-master /etc/hosts && sed -i "s/^.* spark-master .*$/$MASTER_IP spark-master $MASTER/" /etc/hosts || echo $MASTER_IP spark-master $MASTER >> /etc/hosts
grep -q spark-worker /etc/hosts && sed -i "s/^.* spark-worker .*$/$WORKER_IP spark-worker $WORKER/" /etc/hosts || echo $WORKER_IP spark-worker $WORKER >> /etc/hosts
grep -q spark-client /etc/hosts && sed -i "s/^.* spark-client .*$/$CLIENT_IP spark-client $CLIENT/" /etc/hosts || echo $CLIENT_IP spark-client $CLIENT >> /etc/hosts
grep -q kafka-1      /etc/hosts && sed -i "s/^.* kafka-1 .*$/$KAFKA1_IP kafka-1 $KAFKA1/" /etc/hosts || echo $KAFKA1_IP kafka-1 $KAFKA1 >> /etc/hosts
grep -q kafka-2      /etc/hosts && sed -i "s/^.* kafka-2 .*$/$KAFKA2_IP kafka-2 $KAFKA2/" /etc/hosts || echo $KAFKA2_IP kafka-2 $KAFKA2 >> /etc/hosts
EOF

echo "Done"
