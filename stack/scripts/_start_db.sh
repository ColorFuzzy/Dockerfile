#!/usr/bin/env bash


# PostgreSQL for Django/DeliveryService
chown -R postgres "$PGDATA"
chmod g+s /run/postgresql
chown -R postgres:postgres /run/postgresql