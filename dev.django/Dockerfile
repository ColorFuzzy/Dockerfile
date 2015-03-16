FROM python:2.7
MAINTAINER Color Fuzzy <color.fuzzy@gmail.com>

RUN apt-get update
RUN apt-get install libmemcached-dev mg vim

RUN cd / \
 && mkdir \
 && venv \
 && cd venv \
 && virtualenv DeliveryHeroChina

COPY ./requirements.pip /tmp/requirements.pip

RUN source /venv/DeliveryHeroChina/bin/activate \
 && pip install -i http://pypi.douban.com/simple --timeout 120 -r /tmp/requirements.pip
 && rm /tmp/requirements.pip
