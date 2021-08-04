####################
# User vars
####################
echo "Are you using raspberry pi? [y/N]"
read RASPBERRY_PI
RASPBERRY_PI=${RASPBERRY_PI:-n}

if [ "$RASPBERRY_PI" = "y" ]; then
	echo "What is the mount path of your ssd? (probably /mnt/something)"
	read EXTERNAL_SSD_MOUNT
	EXTERNAL_SSD_MOUNT=${EXTERNAL_SSD_MOUNT:-/mnt/ssd}
fi

####################
# Security settings
####################

# Go Ethereum: https://geth.ethereum.org/docs/interface/private-network#setting-up-networking
sudo ufw allow 30303:30305/tcp comment 'Go Ethereum'
sudo ufw allow 30303:30305/udp comment 'Go Ethereum'

# Teku port number is coincidence https://gist.github.com/Larrypcdotcom/fcd4e79c2cf02ce37ec6ed9797beca2c#ports
sudo ufw allow 9001/tcp comment 'Roketpool arbitrary default port'
sudo ufw allow 9001/udp comment 'Roketpool arbitrary default port'

# Prysm: https://docs.prylabs.network/docs/prysm-usage/p2p-host-ip/#incoming-p2p-connection-prerequisites
sudo ufw allow 13000/tcp comment 'Prysm node'
sudo ufw allow 13000/udp comment 'Prysm node'

# Lighthouse: https://lighthouse-book.sigmaprime.io/advanced_networking.html
# Nimbus: https://nimbus.guide/health.html#set-up-port-forwarding
sudo ufw allow 9000/tcp comment 'Lighthouse node'
sudo ufw allow 9000/udp comment 'Lighthouse node'

sudo ufw enable

###################
# Rocketpool setup
###################

# https://docs.rocketpool.net/guides/node/docker.html#downloading-the-rocket-pool-cli
mkdir -p ~/bin

# Get the relevant executable
if [ "$RASPBERRY_PI" = "y" ]; then
	wget https://github.com/rocket-pool/smartnode-install/releases/latest/download/rocketpool-cli-linux-amd64 -O ~/bin/rocketpool
else
	wget https://github.com/rocket-pool/smartnode-install/releases/latest/download/rocketpool-cli-linux-arm64 -O ~/bin/rocketpool
fi

chmod +x ~/bin/rocketpool

echo "export PATH=~/bin/:$PATH" >> ~/.zshrc
source ~/.zshrc

# If needed for PI, change docker data location
if [ "$RASPBERRY_PI" = "y" ]; then
	echo "{ \"data-root\": \"$EXTERNAL_SSD_MOUNT/docker\" }"
	sudo systemctl restart docker
fi

# Initialize rocketpool service
rocketpool service install
source ~/.zshrc

rocketpool service config

#################
# Initial start
#################

rocketpool service start

# Get some stats to verify we are good
rocketpool service stats

# User interaction
rocketpool wallet init

# Commands to run manually
# rocketpool node register
# rocketpool node deposit