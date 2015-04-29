#!/usr/bin/env bash

DB=/home/exthen/ColorFuzzy/docker/db
SRC=/home/exthen/ColorFuzzy/docker/src

sudo docker run \
     --name server \
     -t \
     -i \
     -p 4101:27017 \
     -p 4102:5432 \
     -p 4103:6379 \
     -v $DB:/db \
     -v $SRC:/src \
     colorfuzzy/work:server \
     /bin/bash


