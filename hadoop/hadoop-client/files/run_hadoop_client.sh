#!/bin/bash

service oozie start

while [ 1 ];
do
        tail /var/log/oozie/*.log
        sleep 1
done

