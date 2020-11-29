#!/bin/bash

docker-machine start default

cd /home/ubuntu
docker-compose build
