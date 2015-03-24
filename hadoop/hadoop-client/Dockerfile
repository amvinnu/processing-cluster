# Spark
FROM hadoop-base

# Install some tools required for the setup script
RUN yum install -y epel-release
RUN yum install -y sshpass
RUN yum install -y tomcat

# Install Spark 
RUN yum install -y spark-core spark-python

# Oozie
RUN yum install -y oozie unzip
RUN curl -o /var/lib/oozie/ext-2.2.zip http://dev.sencha.com/deploy/ext-2.2.zip
RUN [ ! -d /var/lib/oozie/ext-2.2 ] && cd /var/lib/oozie && unzip ext-2.2.zip && chown -R oozie:oozie /var/lib/oozie/ext-2.2

# OOZIE ports
EXPOSE 11000

ADD files /root/hadoop_client_files

ENTRYPOINT ["/root/hadoop_client_files/default_cmd"]
