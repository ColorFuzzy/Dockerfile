FROM colorfuzzy/dockerfile:base
MAINTAINER Color Fuzzy <color.fuzzy@gmail.com>

#### get the `source` command & update
RUN apt-get update
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

#----------------------------------------------------------
# 安装django开发环境
#----------------------------------------------------------

## 基本的依赖包
RUN apt-get install -y --no-install-recommends libgeos-dev binutils python-gdal

## setup env
RUN cd / \
    && mkdir venv \
    && cd venv \
    && virtualenv DeliveryHeroChina
COPY ./requirements_django.pip /tmp/requirements_django.pip
# memcached lib for pip
RUN apt-get install -y --no-install-recommends libmemcached-dev
RUN source /venv/DeliveryHeroChina/bin/activate \
    && pip install --timeout 180 -r /tmp/requirements_django.pip \
    && rm /tmp/requirements_django.pip

# package bugfix(有的版本需要, 有的版本不需要, 这里先注释掉)
# RUN sed -i '113s/()/()[:-6]/' /venv/DeliveryHeroChina/lib/python2.7/site-packages/django/contrib/gis/geos/libgeos.py

VOLUME /var/log/DeliveryHeroChina


#----------------------------------------------------------
# 安装cc开发环境
#----------------------------------------------------------

## setup env
RUN cd /venv \
 && virtualenv Management
COPY ./requirements_cc.pip /tmp/requirements_cc.pip
RUN source /venv/Management/bin/activate \
 && pip install --timeout 180 -r /tmp/requirements_cc.pip \
 && rm /tmp/requirements_cc.pip

VOLUME /var/log/Management


#----------------------------------------------------------
# 安装配送开发环境
#----------------------------------------------------------



#### 清理软件库缓存, 减小镜像大小
RUN rm -rf /var/lib/apt/lists/*
