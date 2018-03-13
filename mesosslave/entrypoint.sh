#!/bin/bash

zk_masters="zk://"
ids=$(curl -sS --unix-socket /var/run/docker.sock http:/containers/json?all=true | jq '.[] | select(.Image=="mesos_master") | select(.HostConfig["NetworkMode"]=="mesos_default") | .["Id"][:12]')

declare -a arr=("$ids")
for i in $arr
do
	id=$(echo $i | cut -c2- | rev | cut -c2- | rev)
	zk_masters=$zk_masters"$id:2181,"
done
zk_masters=$(echo "$zk_masters" | rev | cut -c2- | rev)"/mesos/zk"
echo $zk_masters > /etc/mesos/zk
# cat /etc/mesos/zk
