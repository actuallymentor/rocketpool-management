#!/bin/zsh
source "${0:a:h}/.env"
cd $LOCALPATH
rsync root@$NODEIP:~/.rocketlog "{0:a:h}/logs/rocketlog-$(date)"