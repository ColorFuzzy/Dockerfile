FROM python:2.7
MAINTAINER Color Fuzzy <color.fuzzy@gmail.com>

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get update \
 && apt-get install -y --no-install-recommends libmemcached-dev mg vim \
 && rm -rf /var/lib/apt/lists/*

RUN cd / \
 && mkdir venv \
 && cd venv \
 && virtualenv DeliveryHeroChina

COPY ./requirements.pip /tmp/requirements.pip

RUN source /venv/DeliveryHeroChina/bin/activate \
 && pip install --timeout 120 -r /tmp/requirements.pip \
 && rm /tmp/requirements.pip


