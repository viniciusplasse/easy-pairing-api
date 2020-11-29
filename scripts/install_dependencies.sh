#!/bin/bash

cd /home/ubuntu
# docker-compose build

sudo apt-get update -qq
sudo apt-get install -y nodejs postgresql-client
bundle install
