#
# Base Dockerfile that defines OS and JDK alongwith their versions
#

FROM centos:6.6
ENV OS_VERSION 6.6

RUN yum -y update 
RUN yum install -y curl git tar sudo openssh-server openssh-clients rsync

# passwordless ssh
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

# java
RUN curl -LO 'http://download.oracle.com/otn-pub/java/jdk/7u71-b14/jdk-7u71-linux-x64.rpm' -H 'Cookie: oraclelicense=accept-securebackup-cookie'
RUN rpm -i jdk-7u71-linux-x64.rpm
RUN rm jdk-7u71-linux-x64.rpm

ENV JAVA_HOME /usr/java/default
ENV PATH $PATH:$JAVA_HOME/bin

# /etc/hosts is read-only in docker, hack to work around this
# from http://jasonincode.com/customizing-hosts-file-in-docker/
# RUN cp /etc/hosts /tmp/hosts
# RUN mkdir -p -- /lib-override && cp /lib64/libnss_files.so.2 /lib-override
# RUN sed -i 's:/etc/hosts:/tmp/hosts:g' /lib-override/libnss_files.so.2
# ENV LD_LIBRARY_PATH /lib-override

