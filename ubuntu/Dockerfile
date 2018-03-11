FROM ubuntu:16.04
MAINTAINER Ali sarchami "ali.sarchami"

RUN echo "#!/bin/bash" > /etc/bootstrap.sh && \
    chmod 777 /etc/bootstrap.sh

ENTRYPOINT ["/etc/bootstrap.sh"]
