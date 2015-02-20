#!/bin/bash

source /root/hadoop_files/configure_hadoop.sh

function create_spark_directories() {
    create_hadoop_directories
    echo "creating spark directories"
}

function deploy_spark_files() {
    deploy_hadoop_files
    cp /root/spark_files/log4j.properties /etc/spark/conf
    cp /root/spark_files/spark-env.sh /etc/spark/conf
}		

function configure_spark() {
    configure_hadoop $1
    sed -i s/__MASTER__/$1/ /etc/spark/conf/spark-env.sh
}

function prepare_spark() {
    create_spark_directories
    deploy_spark_files
    configure_spark $1
}
