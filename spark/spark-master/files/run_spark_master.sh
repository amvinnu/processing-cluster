#!/bin/bash

service spark-master restart

while [ 1 ];
do
	tail -f /var/log/spark/*.out
        sleep 1
done
