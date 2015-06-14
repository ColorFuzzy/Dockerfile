#!/usr/bin/env bash

sudo docker rm server  # 移除旧版的server镜像

DB=/home/exthen/ColorFuzzy/docker/db
SRC=/home/exthen/ColorFuzzy/docker/src
DEPLOY=/home/exthen/ColorFuzzy/docker/deploy

# 27017 mongo
# 5432 postgresql
# 6379 redis
# 8888 django
# 8002 cc
# 8080 delivery
# 8088 delivery admin
sudo docker run \
     --name server \
     --rm \
     -t \
     -i \
     -p 4101:27017 \
     -p 4102:5432 \
     -p 4103:6379 \
     -p 4001:8888 \
     -p 4002:8002 \
     -p 4003:8080 \
     -p 4004:8088 \
     -v $DEPLOY:/deploy \
     -v $DB/postgresql:/db/postgresql \
     -v $DB/mongodb:/db/mongodb \
     -v $DB/redis:/db/redis \
     -v $SRC:/src \
     -v $SRC/DeliveryService:/venv/DeliveryService/src/github.com/WaimaiChaoren/DeliveryService \
     colorfuzzy/dockerfile:server \
     /bin/bash


