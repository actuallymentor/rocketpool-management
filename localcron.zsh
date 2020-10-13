#!/bin/zsh
source "${0:a:h}/.env"
cd $LOCALPATH
rsync "root@$NODEIP:~/rocket.resources.csv" "${0:a:h}/logs/rocketlog-$(date).csv"
