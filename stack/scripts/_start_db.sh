#!/usr/bin/env bash

#--------------------------------------------------------------
## PostgreSQL相关文件的权限设置(多服务共用, 使用不同的库)
chown -R postgres "$PGDATA"
chmod g+s /run/postgresql
chown -R postgres:postgres /run/postgresql

## PostgreSQL配置文件
# postgresql.conf
# 注意相关文件的位置

gosu postgres /usr/lib/postgresql/9.1/bin/pg_ctl stop  # 先尝试关闭
gosu postgres /usr/lib/postgresql/9.1/bin/pg_ctl start -l /var/log/postgresql/postgresql.docker.log  # 然后运行


#--------------------------------------------------------------
# Mongo基本设置(多服务共用, 使用不同的库)
chown -R mongodb /db/mongodb

mongod --shutdown --dbpath /db/mongodb  # 先尝试关闭
mongod --fork --dbpath /db/mongodb --logpath /var/log/mongo.docker.log  # 然后运行