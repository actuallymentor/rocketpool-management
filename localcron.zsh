#!/bin/zsh
source ./.env
cd $LOCALPATH
rsync root@$NODEIP:~/.rocketlog "./logs/rocketlog-$(date)"