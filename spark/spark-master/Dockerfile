# Spark
FROM hadoop-master

# Install Spark 
# Spark
RUN yum install -y spark-core spark-python spark-master spark-history-server

# export SPARK_MASTER_PORT=7077 from spark-env.sh
# SPARK_MASTER_WEBUI_PORT=18080 from spark-env.sh

EXPOSE 7077 18080

ADD files /root/spark_master_files

RUN chmod +x /root/spark_master_files/default_cmd

ENTRYPOINT ["/root/spark_master_files/default_cmd"]
