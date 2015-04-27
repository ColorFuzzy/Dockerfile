FROM python:2.7
MAINTAINER Color Fuzzy <color.fuzzy@gmail.com>

###############################
##### global setup        #####
###############################

## get the `source` command & update
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get update


###############################
##### django server setup #####
###############################

## setup env
RUN cd / \
 && mkdir venv \
 && cd venv \
 && virtualenv DeliveryHeroChina
COPY ./requirements_django.pip /tmp/requirements.pip
# memcached lib for pip
RUN apt-get install -y --no-install-recommends libmemcached-dev
RUN source /venv/DeliveryHeroChina/bin/activate \
 && pip install --timeout 180 -r /tmp/requirements.pip \
 && rm /tmp/requirements.pip

## install packages
RUN apt-get install -y --no-install-recommends mg vim net-tools git
RUN apt-get install -y --no-install-recommends openssh-client openssh-server
RUN apt-get install -y --no-install-recommends libgeos-dev binutils python-gdal

## package bugfix
RUN sed -i '113s/()/()[:-6]/' /venv/DeliveryHeroChina/lib/python2.7/site-packages/django/contrib/gis/geos/libgeos.py

## ignore log file
VOLUME /var/log/DeliveryHeroChina


###############################
####### cc server setup #######
###############################

## setup env
RUN cd /venv \
 && virtualenv Management
COPY ./requirements_cc.pip /tmp/requirements.pip
RUN source /venv/Management/bin/activate \
 && pip install --timeout 180 -r /tmp/requirements.pip \
 && rm /tmp/requirements.pip

## ignore log folder
VOLUME /var/log/Management


###############################
##### cleanup & others    #####
###############################

## install packages
RUN apt-get install -y --no-install-recommends nginx

RUN rm -rf /var/lib/apt/lists/*