# Based on 
# https://github.com/amplab/docker-scripts.git

FROM base

# Setup a volume for data
VOLUME ["/data"]

# Setup CDH repo
RUN curl http://archive.cloudera.com/cdh5/redhat/6/x86_64/cdh/cloudera-cdh5.repo -o /etc/yum.repos.d/cloudera-cdh5.repo
RUN sed -i "s|cdh/5/|cdh/5.3.1/|" /etc/yum.repos.d/cloudera-cdh5.repo

# Hadoop
RUN yum install -y hadoop-mapreduce hadoop-0.20-mapreduce hadoop-client

# Docker messes up /etc/hosts and adds two entries for 127.0.0.1
# we try to recover from that by giving /etc/resolv.conf and therefore
# the nameserver priority
RUN sed -i s/"files dns"/"dns files"/ /etc/nsswitch.conf

ADD hadoop-files /root/hadoop_files

RUN chmod +x /root/hadoop_files/*.sh

