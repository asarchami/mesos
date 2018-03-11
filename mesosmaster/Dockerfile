FROM asarchami/mesosbase
MAINTAINER Ali Sarchami "ali.sarchami@gmail.com"

RUN apt-get update && \
    apt-get install -y zookeeper marathon chronos

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]
