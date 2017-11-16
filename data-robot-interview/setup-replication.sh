#!/bin/bash

set -x

IP_ADDRESS_1=$1
IP_ADDRESS_2=$2
IP_ADDRESS_3=$3

CONFIG='config={"_id":"my-mongo-set","members":[{"_id":0,"host":"'"$IP_ADDRESS_1"':27017"},{"_id":1,"host":"'"$IP_ADDRESS_2"':27017"},{"_id":2,"host":"'"$IP_ADDRESS_3"':27017"}]}'

CONTAINER_ID=$(docker ps -aqf "name=mongo_node")
docker exec -it $CONTAINER_ID mongo --eval "$CONFIG;rs.initiate(config)"
sleep 10
docker exec -it $CONTAINER_ID mongo --eval "rs.status()"