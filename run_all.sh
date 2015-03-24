#! /bin/bash

cwd=`cd "$(dirname "$0")" && pwd`

source $cwd/env.sh
$cwd/stop_all.sh

export EXTRA_FLAGS=""

function addOrReplaceHost() {
  local container_name="$1"
  local fqhn="$2"

  local ip=`docker inspect $container_name | grep -i ipaddress | awk -F'"' '{print $4}'`

  echo "container_name=${container_name}, fqhn=${fqhn}, ip=${ip}"

  grep -q $container_name /etc/hosts && sed -i "s/^.* $container_name .*$/$ip $container_name $fqhn/" /etc/hosts || echo $ip $container_name $fqhn >> /etc/hosts
}

if [ -f /etc/redhat-release ]
then
 EXTRA_FLAGS="--privileged"
fi

# is typically 172.17.42.1
DOCKER_BRIDGE_ADDR=$(ifconfig | grep -A1 docker0 | grep "inet addr" | awk -F':' '{print $2}' | awk '{print $1}')

echo "Starting skydns"
docker run $EXTRA_FLAGS -d -p $DOCKER_BRIDGE_ADDR:53:53/udp --name skydns crosbymichael/skydns -nameserver 8.8.8.8:53 -domain $DOMAIN

echo "Starting skydock"
docker run $EXTRA_FLAGS -d -v /var/run/docker.sock:/docker.sock --name skydock crosbymichael/skydock -ttl 30 -environment $ENVRN -s /docker.sock -domain $DOMAIN -name skydns

echo "Starting Master ...."
docker run $EXTRA_FLAGS -h $HDP_MASTER -d --name master --dns $DOCKER_BRIDGE_ADDR -e MASTER_HOST=$HDP_MASTER ${NAMESPACE}hadoop-master
addOrReplaceHost master $HDP_MASTER
echo "Waiting for Master to come up ...."
sleep 30

IFS=',' read -a hdpworkers <<< "$hadoop_worker_list"
for hdp_worker in ${hdpworkers[@]}; do
  IFS='.' read -a hdp_worker_parts <<< "$hdp_worker" 
  hdp_worker_name=${hdp_worker_parts[0]}
  echo "Starting $hdp_worker_name"
  docker run $EXTRA_FLAGS -h $hdp_worker -d --name $hdp_worker_name --dns $DOCKER_BRIDGE_ADDR -e MASTER_HOST=$HDP_MASTER ${NAMESPACE}hadoop-worker
  addOrReplaceHost $hdp_worker_name $hdp_worker
  echo "Waiting for Worker to come up ...."
  sleep 10
done


echo "Starting Client ...."
docker run $EXTRA_FLAGS -h $CLIENT -d --name client --dns $DOCKER_BRIDGE_ADDR -e MASTER_HOST=$HDP_MASTER ${NAMESPACE}hadoop-client
addOrReplaceHost client $CLIENT
echo "Waiting for Client to come up ...."
sleep 30

IFS=',' read -a kafkaservers <<< "$kafka_list"
for kafkas in ${kafkaservers[@]}; do
  IFS=':' read -a kafkacomponents <<< "$kafkas" 
  brokerid=${kafkacomponents[0]}
  kafkahost=${kafkacomponents[1]}
  IFS='.' read -a kafkaparts <<< "$kafkahost" 
  kafkaname=${kafkaparts[0]}
  echo "Starting $kafkaname"
  docker run $EXTRA_FLAGS -h $kafkahost -d --name $kafkaname --dns $DOCKER_BRIDGE_ADDR -e KAFKA_ZOOKEEPER_CONNECT=$zk_connect -e KAFKA_BROKER_ID=$brokerid -e KAFKA_HOST_NAME=$kafkahost ${NAMESPACE}kafka
  addOrReplaceHost $kafkaname $kafkahost
  echo "Waiting for $kafkaname to come up"
  sleep 10
done

echo "Starting Kafka web console ...."
docker run $EXTRA_FLAGS -d --dns $DOCKER_BRIDGE_ADDR -h $KAFKA_CONSOLE --name kafka-console hwestphal/kafka-web-console
addOrReplaceHost kafka-console $KAFKA_CONSOLE
echo "Waiting for Kafka web console to come up ...."
sleep 10

echo "Done"

