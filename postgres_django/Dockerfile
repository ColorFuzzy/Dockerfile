FROM postgres:9.1
MAINTAINER Color Fuzzy <color.fuzzy@gmail.com>

ENV POSTGIS_MAJOR 1.5

RUN echo deb http://http.debian.net/debian wheezy-backports main >> /etc/apt/sources.list
RUN apt-get update \
      && apt-get install -y --no-install-recommends \
           postgresql-$PG_MAJOR-postgis \
           postgis=$POSTGIS_MAJOR \
      && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /docker-entrypoint-initdb.d
COPY ./initdb-postgis.sh /docker-entrypoint-initdb.d/postgis.sh