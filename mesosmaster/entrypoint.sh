#!/bin/bash

function get_containers {
    if [[ -z "$1" ]]; then
        echo "$(curl -sS --unix-socket /var/run/docker.sock http:/containers/json?all=true)"
    else
        exit
    fi
}

function get_id {
    jq '.[] | select(.Image=="mesos_master") | select(.HostConfig["NetworkMode"]=="mesos_default") | .["Id"][:12]' $1
}

function current_container {
    echo "$(curl -sS --unix-socket /var/run/docker.sock http:/containers/$HOSTNAME/json)"
}

zk_masters="zk://"
ids=$(get_containers | get_id)
declare -a arr=("$ids")
number_of_masters=0
for i in $arr
do
	id=$(echo $i | cut -c2- | rev | cut -c2- | rev)
	zk_masters=$zk_masters"$id:2181,"
    (( number_of_masters+=1 ))
done
zk_masters=$(echo "$zk_masters" | rev | cut -c2- | rev)"/mesos/zk"
echo $zk_masters > /etc/mesos/zk
# cat /etc/mesos/zk

container_id=$(current_container | jq '.Name')
container_id=$(echo $container_id | rev | cut -d _ -f 1 | cut -c2-)
echo $container_id > /etc/zookeeper/conf/myid
# cat /etc/zookeeper/conf/myid

name_ids=$(curl -sS --unix-socket /var/run/docker.sock http:/containers/json?all=true | jq '.[] | select(.Image=="mesos_master") | select(.HostConfig["NetworkMode"]=="mesos_default") | .["Names"][0], .["Id"][:12]')
# echo "$name_ids"

declare -a arr=("$name_ids")
flag=0
servers=""
for i in $arr
do
    if [[ $flag = 0 ]]; then
        id=$(echo $i | rev | cut -d _ -f 1 | cut -c2-)
        servers=$servers"server."$id=
        flag=1
    else
        id=$(echo $i | cut -c2- | rev | cut -c2- | rev)
        servers=$servers$id$":2888:3888\n"
        flag=0
    fi
done
echo -e "$servers" >> /etc/zookeeper/conf/zoo.cfg

number_of_masters=$(($number_of_masters / 2 + 1))
echo $number_of_masters > /etc/mesos-master/quorum
# cat /etc/mesos-master/quorum

container_name=$(current_container | jq '.["Id"][:12]' | cut -c2- | rev | cut -c2- | rev)
echo "$container_name" > /etc/mesos-master/ip
cp /etc/mesos-master/ip /etc/mesos-master/hostname
cat /etc/mesos-master/hostname
