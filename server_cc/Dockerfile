FROM colorfuzzy/work:server_django
MAINTAINER Color Fuzzy <color.fuzzy@gmail.com>

## get the `source` command & update
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get update

## setup env
RUN cd /venv \
 && virtualenv Management
COPY ./requirements.pip /tmp/requirements.pip
RUN source /venv/Management/bin/activate \
 && pip install --timeout 120 -r /tmp/requirements.pip \
 && rm /tmp/requirements.pip

# install packages
RUN apt-get install -y --no-install-recommends nginx
RUN rm -rf /var/lib/apt/lists/*

VOLUME /var/log/Management

