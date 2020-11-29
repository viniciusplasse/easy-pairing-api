#!/bin/bash

cd /home/ubuntu
# docker-compose down

pid=`pgrep ruby`
if [ -n  "$pid" ]
then
	kill $pid
fi
