# Based on 
# https://github.com/amplab/docker-scripts.git

FROM hadoop-base

# Hadoop
RUN yum install -y hadoop-hdfs-datanode hadoop-yarn-nodemanager 

# HDFS ports
EXPOSE 50070 50470 9000 50075 50475 50010 50020 50090

# YARN ports
EXPOSE 8088 8031 8032 8033 50060

