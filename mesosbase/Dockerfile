FROM ubuntu:16.04
MAINTAINER Ali Sarchami "ali.sarchami@gmail.com"

ENV MESOS_VERSION=1.5.0

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF && \
    echo "deb http://repos.mesosphere.io/ubuntu xenial main" | \
        tee /etc/apt/sources.list.d/mesosphere.list && \
    apt-get update && \
    apt-get install -y mesos jq curl
