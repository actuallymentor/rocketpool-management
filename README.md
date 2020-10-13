# Rocketpool management

My notes on keeping my rocketpool online and happy. Use for inspiration if you like but don't use anything if you don't understand it.

Requirements:

- An `.env` file with environment vars

```

# User & API token of Pushover ( push notification service )
export PUSHOVERUSER=
export PUSHOVERAPITOKEN=

# Locations of logs and csv files
export ROCKETCRONLOG=/var/log/rocket.cron
export ROCKETCSVLOG=~/rocket.resources.csv

# At what % utilisation should a push notification be sent?
export RAMWARNINGPERCENT=80
export SWAPWARNINGPERCENT=20

# How many samples of CPu usage should be take per measurement
export CPUSAMPLESPERMEASUREMENT=20

# How long do we wait between CPU samples
export CPUSAMPLEDELAYINSECONDS=.5

# The local path of this repository and the remote IP of the node
# Only useful if you use the localcron.zsh
export LOCALPATH=~/dev/rocketpool-scripts
export NODEIP=1.1.1.1
```


## Faucets

- https://prylabs.net/participate 
- https://faucet.goerli.mudit.blog/ 
- https://goerli-faucet.slock.it/ 
