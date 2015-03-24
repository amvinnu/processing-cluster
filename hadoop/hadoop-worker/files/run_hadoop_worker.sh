#!/bin/bash

while [ 1 ];
do
        tail /var/log/hadoop-hdfs-datanode/*.log
        sleep 1
done

