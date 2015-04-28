# 安装基本的软件
FROM debian:wheezy
MAINTAINER Color Fuzzy <color.fuzzy@gmail.com>

#### 开始更新软件库, 这个在后面会删除缓存的数据(最后一行)
RUN apt-get update
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

#----------------------------------------------------------
# 基本的编译和开发环境
# 参考:
# https://github.com/docker-library/buildpack-deps/tree/master/wheezy
#----------------------------------------------------------

RUN apt-get install -y --no-install-recommends \
        	ca-certificates \
	        curl \
	        wget
RUN apt-get install -y --no-install-recommends \
		    bzr \
		    git \
		    mercurial \
		    openssh-client \
		    subversion
RUN apt-get install -y \
	    	autoconf \
		    build-essential \
		    imagemagick \
		    libbz2-dev \
		    libcurl4-openssl-dev \
		    libevent-dev \
		    libffi-dev \
		    libglib2.0-dev \
		    libjpeg-dev \
		    liblzma-dev \
		    libmagickcore-dev \
		    libmagickwand-dev \
		    libmysqlclient-dev \
		    libncurses-dev \
		    libpq-dev \
    		libreadline-dev \
	    	libsqlite3-dev \
		    libssl-dev \
		    libxml2-dev \
		    libxslt-dev \
		    libyaml-dev \
		    zlib1g-dev


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
# https://registry.hub.docker.com/_/redis/
# https://github.com/docker-library/redis/tree/5a480f7c9f05822c31204a7197d209ef9db1a32c/2.8
#----------------------------------------------------------

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r redis && useradd -r -g redis redis

ENV REDIS_VERSION 2.8.19
ENV REDIS_DOWNLOAD_URL http://download.redis.io/releases/redis-2.8.19.tar.gz
ENV REDIS_DOWNLOAD_SHA1 3e362f4770ac2fdbdce58a5aa951c1967e0facc8

# for redis-sentinel see: http://redis.io/topics/sentinel
RUN apt-get install -y curl
RUN buildDeps='gcc libc6-dev make' \
	&& set -x \
	&& apt-get install -y $buildDeps --no-install-recommends \
	&& mkdir -p /usr/src/redis \
	&& curl -sSL "$REDIS_DOWNLOAD_URL" -o redis.tar.gz \
	&& echo "$REDIS_DOWNLOAD_SHA1 *redis.tar.gz" | sha1sum -c - \
	&& tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1 \
	&& rm redis.tar.gz \
	&& make -C /usr/src/redis \
	&& make -C /usr/src/redis install \
	&& rm -r /usr/src/redis

VOLUME /db/redis


#----------------------------------------------------------
# 安装python 2.7
# 参考:
# https://registry.hub.docker.com/_/python/
# https://github.com/docker-library/python/blob/a736fc19a99afe3d77ba108263aad53bd1b9ab65/2.7/Dockerfile
#----------------------------------------------------------

ENV PYTHON_VERSION 2.7.9

# gpg: key 18ADD4FF: public key "Benjamin Peterson <benjamin@python.org>" imported
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys C01E1CAD5EA2C4F0B8E3571504C367C218ADD4FF

RUN set -x \
	&& mkdir -p /usr/src/python \
	&& curl -SL "https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz" -o python.tar.xz \
	&& curl -SL "https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz.asc" -o python.tar.xz.asc \
	&& gpg --verify python.tar.xz.asc \
	&& tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz \
	&& rm python.tar.xz* \
	&& cd /usr/src/python \
	&& ./configure --enable-shared --enable-unicode=ucs4 \
	&& make -j$(nproc) \
	&& make install \
	&& ldconfig \
	&& curl -SL 'https://bootstrap.pypa.io/get-pip.py' | python2 \
	&& find /usr/local \
		\( -type d -a -name test -o -name tests \) \
		-o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
		-exec rm -rf '{}' + \
	&& rm -rf /usr/src/python

# install "virtualenv", since the vast majority of users of this image will want it
RUN pip install virtualenv


#----------------------------------------------------------
# 安装nginx 1.8
# 参考:
#----------------------------------------------------------



#----------------------------------------------------------
# 安装常用的开发包
#----------------------------------------------------------

RUN apt-get install -y --no-install-recommends mg vim net-tools git
RUN apt-get install -y --no-install-recommends openssh-client openssh-server
RUN apt-get install -y --no-install-recommends libgeos-dev binutils python-gdal
RUN apt-get install -y --no-install-recommends nginx



#### 清理软件库缓存, 减小镜像大小
RUN rm -rf /var/lib/apt/lists/*