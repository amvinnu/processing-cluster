#!/usr/bin/env bash

export STANDALONE_SPARK_MASTER_HOST=__MASTER__

### Let's run everything with JVM runtime, instead of Scala
export SPARK_LAUNCH_WITH_SCALA=0
export SPARK_LIBRARY_PATH=${SPARK_HOME}/lib
export SCALA_LIBRARY_PATH=${SPARK_HOME}/lib
export SPARK_MASTER_WEBUI_PORT=18080
export SPARK_MASTER_PORT=7077
export SPARK_WORKER_PORT=7078
export SPARK_WORKER_WEBUI_PORT=18081
export SPARK_WORKER_DIR=/var/run/spark/work
export SPARK_LOG_DIR=/var/log/spark
export SPARK_PID_DIR='/var/run/spark/'

export HADOOP_HOME="/usr/lib/hadoop"
export HADOOP_CONF_DIR="/etc/hadoop/conf"

if [ -n "$HADOOP_HOME" ]; then
  export LD_LIBRARY_PATH=:/lib/native
fi

export SPARK_WORKER_CORES=1
export SPARK_MEM=800m
export SPARK_WORKER_MEMORY=1500m
export SPARK_MASTER_MEM=1500m
export SPARK_WORKER_INSTANCES=1

#SPARK_JAVA_OPTS+=" -Dspark.akka.logLifecycleEvents=true "
#SPARK_JAVA_OPTS+="-Dspark.kryoserializer.buffer.mb=10 "
#SPARK_JAVA_OPTS+="-verbose:gc -XX:-PrintGCDetails -XX:+PrintGCTimeStamps "
#export SPARK_JAVA_OPTS
#SPARK_DAEMON_JAVA_OPTS+=" -Dspark.akka.logLifecycleEvents=true "
#export SPARK_DAEMON_JAVA_OPTS

