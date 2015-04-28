# 安装基本的软件
FROM debian:wheezy

# 开始更新软件库, 这个在后面会删除缓存的数据(最后一行)
RUN apt-get update
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

#----------------------------------------------------------
# 安装gosu命令行工具, 用于代替sudo/su命令(因为它们的有些行为会导致莫名的bug)
# 参考:
# https://registry.hub.docker.com/_/postgres/
#----------------------------------------------------------
# grab gosu for easy step-down from root
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN apt-get update && apt-get install -y curl \
	&& curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
	&& curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
	&& gpg --verify /usr/local/bin/gosu.asc \
	&& rm /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu


#----------------------------------------------------------
# 安装PostgreSQL 9.1 + PostGis1.5
# 参考:
# https://registry.hub.docker.com/_/postgres/
# https://github.com/docker-library/postgres/tree/e616341507a7beec3a161b0a366ba0d3400328fd/9.1
# https://github.com/ColorFuzzy/Dockerfile/tree/master/postgres_django
#----------------------------------------------------------

## 安装PostgreSQL 9.1

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r postgres && useradd -r -g postgres postgres

# make the "en_US.UTF-8" locale so postgres will be utf-8 enabled by default
RUN apt-get install -y locales \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

RUN apt-key adv --keyserver pool.sks-keyservers.net --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
ENV PG_MAJOR 9.1
ENV PG_VERSION 9.1.15-1.pgdg70+1
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ wheezy-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list

RUN apt-get update \
	&& apt-get install -y postgresql-common \
	&& sed -ri 's/#(create_main_cluster) .*$/\1 = false/' /etc/postgresql-common/createcluster.conf \
	&& apt-get install -y \
	           postgresql-$PG_MAJOR=$PG_VERSION \
		       postgresql-contrib-$PG_MAJOR=$PG_VERSION

RUN mkdir -p /var/run/postgresql && chown -R postgres /var/run/postgresql
ENV PATH /usr/lib/postgresql/$PG_MAJOR/bin:$PATH
ENV PGDATA /db/postgresql
VOLUME /db/postgresql


## 安装PostGis 1.5

ENV POSTGIS_MAJOR 1.5
RUN echo deb http://http.debian.net/debian wheezy-backports main >> /etc/apt/sources.list
RUN apt-get update \
      && apt-get install -y --no-install-recommends \
                 postgresql-$PG_MAJOR-postgis


#----------------------------------------------------------
# 安装mongo 2.6
# 参考:
# https://registry.hub.docker.com/_/mongo/
# https://github.com/docker-library/mongo/tree/faab1fed954b4267168fd22b4bc534a62365e7a2/2.6
#----------------------------------------------------------

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r mongodb && useradd -r -g mongodb mongodb

# grab gosu for easy step-down from root
RUN apt-get install -y curl numactl
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
	&& curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
	&& gpg --verify /usr/local/bin/gosu.asc \
	&& rm /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu

ENV MONGO_RELEASE_FINGERPRINT DFFA3DCF326E302C4787673A01C4E7FAAAB2461C
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys $MONGO_RELEASE_FINGERPRINT

ENV MONGO_VERSION 2.6.9

RUN curl -SL "https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-$MONGO_VERSION.tgz" -o mongo.tgz \
	&& curl -SL "https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-$MONGO_VERSION.tgz.sig" -o mongo.tgz.sig \
	&& gpg --verify mongo.tgz.sig \
	&& tar -xvf mongo.tgz -C /usr/local --strip-components=1 \
	&& rm mongo.tgz*

VOLUME /db/mongodb


#----------------------------------------------------------
# 安装redis 2.8
# 参考:
#
#----------------------------------------------------------


#----------------------------------------------------------
# 安装python 2.7
# 参考:
#
#----------------------------------------------------------


#----------------------------------------------------------
# 安装nginx 1.8
# 参考:
#
#----------------------------------------------------------

#----------------------------------------------------------
# 安装其他的应用程序
# 参考:
#
#----------------------------------------------------------



# 清理软件库缓存, 减小镜像大小
RUN rm -rf /var/lib/apt/lists/*