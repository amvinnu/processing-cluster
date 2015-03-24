#! /bin/bash

#export NAMESPACE=""
export NAMESPACE="amvinnu/"

export DOMAIN=test.corp
export ENVRN=dev

export HDP_MASTER=master.hadoop-master.$ENVRN.$DOMAIN

export HDP_WORKER_1=worker-1.hadoop-worker.$ENVRN.$DOMAIN
export HDP_WORKER_2=worker-2.hadoop-worker.$ENVRN.$DOMAIN
export hadoop_worker_list="$HDP_WORKER_1,$HDP_WORKER_2"

export KAFKA_1=kafka-1.kafka.$ENVRN.$DOMAIN
export KAFKA_2=kafka-2.kafka.$ENVRN.$DOMAIN
export kafka_list="1:$KAFKA_1,2:$KAFKA_2"
export zk_connect="$HDP_MASTER:2181"

export KAFKA_CONSOLE=kafka-console.kafka-web-console.$ENVRN.$DOMAIN

export CLIENT=client.hadoop-client.$ENVRN.$DOMAIN
