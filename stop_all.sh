#! /bin/bash

cwd=`cd "$(dirname "$0")" && pwd`

source $cwd/env.sh

echo "Stopping any running docker containers"

function stopAndRemove() {
  local container_name="$1"

  docker ps    | grep -q $container_name && docker stop  $container_name
  docker ps -a | grep -q $container_name && docker rm -v $container_name
}

IFS=',' read -a kafkaservers <<< "$kafka_list"
for kafkas in ${kafkaservers[@]}; do
  IFS=':' read -a kafkacomponents <<< "$kafkas"
  brokerid=${kafkacomponents[0]}
  kafkahost=${kafkacomponents[1]}
  IFS='.' read -a kafkaparts <<< "$kafkahost"
  kafkaname=${kafkaparts[0]}
  echo "Stopping $kafkaname"
  stopAndRemove $kafkaname
done

IFS=',' read -a hdpworkers <<< "$hadoop_worker_list"
for hdp_worker in ${hdpworkers[@]}; do
  IFS='.' read -a hdp_worker_parts <<< "$hdp_worker"
  hdp_worker_name=${hdp_worker_parts[0]}
  echo "Stopping $hdp_worker_name"
  stopAndRemove $hdp_worker_name
done

stopAndRemove kafka-console
stopAndRemove client
stopAndRemove master
stopAndRemove skydock
stopAndRemove skydns

echo "Done stopping containers"
