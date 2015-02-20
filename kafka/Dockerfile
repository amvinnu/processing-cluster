#
# Kafka Dockerfile
#
# based on https://github.com/wurstmeister/kafka-docker
#

# Pull base image.
FROM base

RUN curl http://apache.mirrors.lucidnetworks.net/kafka/0.8.2.0/kafka_2.10-0.8.2.0.tgz -o /tmp/kafka_2.10-0.8.2.0.tgz
RUN tar xfz /tmp/kafka_2.10-0.8.2.0.tgz -C /opt

ENV KAFKA_ADVERTISED_PORT=9092
EXPOSE 9092

VOLUME ["/kafka"]

ENV KAFKA_HOME /opt/kafka_2.10-0.8.2.0
ADD start-kafka.sh /usr/bin/start-kafka.sh
ADD broker-list.sh /usr/bin/broker-list.sh
COPY log4j.properties /opt/kafka_2.10-0.8.2.0/config/log4j.properties

CMD start-kafka.sh 

