#! /bin/bash

#export NAMESPACE=""
export NAMESPACE="amvinnu/"

export DOMAIN=test.corp
export ENVRN=dev
export MASTER=master.spark-master.$ENVRN.$DOMAIN
export WORKER1=worker-1.spark-worker.$ENVRN.$DOMAIN
export CLIENT1=client-1.spark-client.$ENVRN.$DOMAIN
export KAFKA1=kafka-1.kafka.$ENVRN.$DOMAIN
export KAFKA2=kafka-2.kafka.$ENVRN.$DOMAIN

