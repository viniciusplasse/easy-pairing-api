#!/bin/bash

cd /home/ubuntu
# docker-compose build

apt-get update -qq
apt-get install -y nodejs postgresql-client
bundle install
