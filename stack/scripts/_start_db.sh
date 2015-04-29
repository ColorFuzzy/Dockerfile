#!/usr/bin/env bash

#--------------------------------------------------------------
# PostgreSQL相关文件的权限设置(多服务共用, 使用不同的库)
chown -R postgres "$PGDATA"
chmod g+s /run/postgresql
chown -R postgres:postgres /run/postgresql

# PostgreSQL配置文件

# PostgreSQL启动方法, 暂停直接kill

#--------------------------------------------------------------
# Mongo基本设置(多服务共用, 使用不同的库)
chown -R mongodb /db/mongodb

# Mongo配置文件

# Mongo启动方法, 暂停直接kill
