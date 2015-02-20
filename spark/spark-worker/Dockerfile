# Spark
FROM hadoop-worker

# Install Spark 
# Spark
RUN yum install -y spark-core spark-python spark-worker

# SPARK_WORKER_PORT=7078 from spark-env.sh
# SPARK_WORKER_WEBUI_PORT=18081 from spark-env.sh

EXPOSE 7078 18081

ADD files /root/spark_worker_files

ENTRYPOINT ["/root/spark_worker_files/default_cmd"]
