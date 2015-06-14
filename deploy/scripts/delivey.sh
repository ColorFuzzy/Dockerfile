#!/usr/bin/env bash

export PATH=/venv/DeliveryService/bin:$PATH

cp /deploy/conf/delivery.app.conf /venv/DeliveryService/src/github.com/WaimaiChaoren/DeliveryService/conf/app.conf
cd /venv/DeliveryService/src/github.com/WaimaiChaoren/DeliveryService
go build main.go
nohup ./main &
