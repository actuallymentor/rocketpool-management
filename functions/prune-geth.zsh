#!/bin/zsh

# Defaults
minimumDiskSpaceinGB=50

# customisation settings
PATH_CONSTRAINING_DISK_SPACE='/' # Depends on your device
ETH1_CONTAINER='rocketpool_eth1' # See docker ps
GETH_VERSION=$( docker exec -i rocketpool_eth1 geth version | grep -Po "(?<=^Version: )[0-9\.]+" ) # See docker exec -i rocketpool_eth1 geth version
ETH1_DATA_VOLUME="eth1clientdata:/ethclient" # See eth1.volumes in  ~/.rocketpool/docker-compose.yml
ETH1_CHAIN_VOLUME_RELATIVE_TO_RP_DIR="/chains/eth1:/setup:ro" # See eth1.volumes in  ~/.rocketpool/docker-compose.yml
RP_ABS_PATH="/home/$(whoami)/.rocketpool"

# df the stats of the path constraining geth
# grep the free space column by "first match of numbers after first 'G   '"
freeDiskSpaceInGB=$( df -BG $PATH_CONSTRAINING_DISK_SPACE | grep -Po "(\d+)(?=G \ *\s+\d+%)" )

# Sanity checks
echo "Path constraining disk space: $PATH_CONSTRAINING_DISK_SPACE"
echo "Is this correct? [y/n]"
read DISKPATHCORRECT
if [ "$DISKPATHCORRECT" = "n" ]; then
	echo "You may change the disk path at the top of this script by editing PATH_CONSTRAINING_DISK_SPACE"
	exit 0
else
	echo "✅ Disk location confirmed"
fi

if grep -q "$ETH1_VOLUME" ~/.rocketpool/docker-compose.yml; then
	echo "✅ Volume $ETH1_DATA_VOLUME is present in ~/.rocketpool/docker-compose.yml"
else
	echo "🛑 Volume $ETH1_DATA_VOLUME does not appear to be present in ~/.rocketpool/docker-compose.yml"
	exit 1
fi

if grep -q "$ETH1_CHAIN_VOLUME_RELATIVE_TO_RP_DIR" ~/.rocketpool/docker-compose.yml; then
	echo "✅ Volume $ETH1_CHAIN_VOLUME_RELATIVE_TO_RP_DIR is present in ~/.rocketpool/docker-compose.yml"
else
	echo "🛑 Volume $ETH1_CHAIN_VOLUME_RELATIVE_TO_RP_DIR does not appear to be present in ~/.rocketpool/docker-compose.yml"
	exit 1
fi


if (( $freeDiskSpaceInGB < $minimumDiskSpaceinGB )); then
	echo "🛑 Free disk space is $freeDiskSpaceInGB, which is under the minimum $minimumDiskSpaceinGB GB"
	exit 1
else
	echo "✅ Free disk space is $freeDiskSpaceInGB GB"
fi

# Stop RP container
echo "Stopping rocketpool ETH1 container"
docker stop rocketpool_eth1

echo "Starting GETH offline prune"
docker run --rm \
	-v $ETH1_DATA_VOLUME \
	-v $RP_ABS_PATH$ETH1_CHAIN_VOLUME_RELATIVE_TO_RP_DIR \
	-ti ethereum/client-go:v$GETH_VERSION \
	snapshot prune-state --goerli --datadir /ethclient/geth

echo "Prune complete, restarting rocketpool ETH1 container"
docker start rocketpool_eth1
