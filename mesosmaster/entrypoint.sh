#!/bin/bash

zk_masters="zk://mesosmaster_1:2181"
for count in $(seq 2 $NO_OF_MASTERS)
do
    zk_masters=$zk_masters", mesosmaster_"$count":2181"
done
zk_masters=$zk_masters"/mesos"
echo $zk_masters > /etc/mesos/zk
cat /etc/mesos/zk

