#!/bin/bash

hadoop_files=( "/root/hadoop_files/core-site.xml"  "/root/hadoop_files/hdfs-site.xml" "/root/hadoop_files/mapred-site.xml" "/root/hadoop_files/yarn-site.xml" "/root/hadoop_files/capacity-scheduler.xml" )

function create_hadoop_directories() {
    echo "creating hadoop directories"

    mkdir /data/namenode
    mkdir /data/datanode
    chown hdfs:hadoop /data/namenode
    chown hdfs:hadoop /data/datanode

    mkdir -p /data/yarn/local
    mkdir -p /data/yarn/logs
    chown -R yarn:hadoop /data/yarn
}

function deploy_hadoop_files() {
    for i in "${hadoop_files[@]}";
    do
        filename=$(basename $i);
        cp $i /etc/hadoop/conf/$filename;
    done
}		

function configure_hadoop() {
    sed -i s/__MASTER__/$1/ /etc/hadoop/conf/core-site.xml
    sed -i s/__MASTER__/$1/ /etc/hadoop/conf/yarn-site.xml
    sed -i s/__MASTER__/$1/ /etc/hadoop/conf/mapred-site.xml
    echo "export JAVA_HOME=/usr/java/default" >> /etc/profile
}

function prepare_hadoop() {
    create_hadoop_directories
    deploy_hadoop_files
    configure_hadoop $1
}
