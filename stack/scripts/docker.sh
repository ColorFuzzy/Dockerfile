#!/usr/bin/env bash

DB=/home/exthen/ColorFuzzy/docker/db
SRC=/home/exthen/ColorFuzzy/docker/src

sudo docker run \
     --name server \
     --rm \
     -t \
     -i \
     -p 4101:27017 \
     -p 4102:5432 \
     -p 4103:6379 \
     -p 4001:8888 \
     -v $DB/postgresql:/db/postgresql \
     -v $DB/mongodb:/db/mongodb \
     -v $DB/redis:/db/redis \
     -v $SRC:/src \
     colorfuzzy/dockerfile:test042901 \
     /bin/bash


