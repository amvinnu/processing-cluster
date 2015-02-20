#!/bin/bash

service spark-worker start

while [ 1 ];
do
        tail -f /var/log/spark/*.out
        sleep 1
done

