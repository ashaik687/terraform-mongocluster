#!/bin/bash

set -x
mkfs -t ext4 /dev/xvdg
mkdir -pv /mongodb/logs
VOLUME_UUID=$(blkid /dev/xvdg | awk -F " " '{print $2}' | awk -F "=" '{print $2}' | sed 's/\"//g')
echo "UUID=$VOLUME_UUID       /mongodb   ext4    defaults,nofail        0" >> /etc/fstab
mount -a
sudo yum update -y
yum install docker -y
systemctl start docker.service
docker pull mongo
docker network create my-mongo-cluster
docker run -p 27017:27017 -v /mongodb/logs:/var/log/mongodb:z --name mongo_node --net my-mongo-cluster -d mongo mongod --replSet my-mongo-set