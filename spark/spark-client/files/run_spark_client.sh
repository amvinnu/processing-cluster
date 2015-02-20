#!/bin/bash

service oozie start

while [ 1 ];
do
        tail -f /var/log/oozie/*.log
        sleep 1
done

