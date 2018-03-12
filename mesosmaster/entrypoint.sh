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
name=$(curl --unix-socket /var/run/docker.sock http:/containers/$HOSTNAME/json | jq '.Name')
id=$(echo $name | rev | cut -d _ -f 1 | cut -c2-)
echo $id > /etc/zookeeper/conf/myid
cat /etc/zookeeper/conf/myid


# zk_masters="zk://mesosmaster_1:2181"
# for count in $(seq 2 $NO_OF_MASTERS)
# do
#     zk_masters=$zk_masters", mesosmaster_"$count":2181"
# done
# zk_masters=$zk_masters"/mesos"
# echo $zk_masters > /etc/mesos/zk
# cat /etc/mesos/zk

# echo ${HOSTNAME}




# # name=$(curl --unix-socket /var/run/docker.sock http:/containers/$HOSTNAME/json | jq '.Name')
# echo $name | cut -c 3- | rev | cut -c2- | rev
# curl --unix-socket /var/run/docker.sock http:/containers/json?all=true | jq '.[] | select(.Image=="mesos_master") | select(.HostConfig["NetworkMode"]=="mesos_default") | .Names'

# count=$(curl --unix-socket /var/run/docker.sock http:/containers/json?all=true | jq '.[] | select(.Image=="mesos_master") | select(.HostConfig["NetworkMode"]=="mesos_default") | .Names | .[]' | wc -l)
# ids=$(curl --unix-socket /var/run/docker.sock http:/containers/json?all=true | jq '.[] | select(.Image=="mesos_master") | select(.HostConfig["NetworkMode"]=="mesos_default") | .["Id"][:12]')

# declare -a arr=("$ids")
# for i in "$arr[@]}"; do echo "$i"; done
