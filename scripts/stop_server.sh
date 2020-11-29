#!/bin/bash

cd /home/ubuntu
# docker-compose down

#!/bin/bash

pid=`pgrep ruby`
if [ -n  "$pid" ]
then
	kill $pid
fi
