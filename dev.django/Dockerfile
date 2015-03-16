FROM python:2.7
MAINTAINER Color Fuzzy <color.fuzzy@gmail.com>

RUN apt-get update
RUN apt-get install libmemcached-dev mg vim

RUN cd / \
 && mkdir \
 && venv \
 && cd venv \
 && virtualenv DeliveryHeroChina

COPY .pip1 /tmp/pip1
COPY .pip2 /tmp/pip2

RUN source /venv/DeliveryHeroChina/bin/activate \
 && pip install -i http://pypi.douban.com/simple --timeout 120 -r /tmp/pip1
RUN source /venv/DeliveryHeroChina/bin/activate \
 && pip install -i http://pypi.douban.com/simple --timeout 120 -r /tmp/pip2
