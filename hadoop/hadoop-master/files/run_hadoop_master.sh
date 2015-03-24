#!/bin/bash

while [ 1 ];
do
	tail /var/log/hadoop-hdfs-namenode/*.log
        sleep 1
done
