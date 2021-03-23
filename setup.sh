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
# deprecation notice: the rocketpool stack standardises the eth2 port to 9001. The eth2-specific firewall rules are superfluous
####################

# Go Ethereum: https://geth.ethereum.org/docs/interface/private-network#setting-up-networking
sudo ufw allow 30303:30305/tcp comment 'Go Ethereum'
sudo ufw allow 30303:30305/udp comment 'Go Ethereum'

# Teku port number is coincidence https://gist.github.com/Larrypcdotcom/fcd4e79c2cf02ce37ec6ed9797beca2c#ports
sudo ufw allow 9001/tcp comment 'Roketpool arbitrary default port'
sudo ufw allow 9001/udp comment 'Roketpool arbitrary default port'

# # Prysm: https://docs.prylabs.network/docs/prysm-usage/p2p-host-ip/#incoming-p2p-connection-prerequisites
# sudo ufw allow 13000/tcp comment 'Prysm node'
# sudo ufw allow 13000/udp comment 'Prysm node'

# # Lighthouse: https://lighthouse-book.sigmaprime.io/advanced_networking.html
# # Teku: https://docs.teku.consensys.net/en/latest/HowTo/Find-and-Connect/Improve-Connectivity/#configuring-ports
# # Nimbus: https://nimbus.guide/troubleshooting.html?highlight=port#address-already-in-use-error
# sudo ufw allow 9000/tcp comment 'Lighthouse, teku and nimbus node'
# sudo ufw allow 9000/udp comment 'Lighthouse, teku and nimbus node'

sudo ufw enable

###################
# Rocketpool setup
###################

# https://docs.rocketpool.net/guides/node/docker.html#downloading-the-rocket-pool-cli
mkdir -p ~/bin

# Get the relevant executable
if [ "$RASPBERRY_PI" = "y" ]; then
	wget https://github.com/rocket-pool/smartnode-install/releases/latest/download/rocketpool-cli-linux-arm64 -O ~/bin/rocketpool
else
	wget https://github.com/rocket-pool/smartnode-install/releases/latest/download/rocketpool-cli-linux-amd64 -O ~/bin/rocketpool
fi

chmod +x ~/bin/rocketpool

echo "export PATH=~/bin/:$PATH" >> ~/.zshrc
source ~/.zshrc
PATH=~/bin/:$PATH

# If needed for PI, change docker data location
if [ "$RASPBERRY_PI" = "y" ]; then
	sudo mkdir -p $EXTERNAL_SSD_MOUNT"/docker" || echo "Folder creation failed"
	echo "{ \"data-root\": \"$EXTERNAL_SSD_MOUNT/docker\" }" | sudo tee -a /etc/docker/daemon.json > /dev/null
fi

# Initialize rocketpool service
rocketpool service install
source ~/.zshrc

rocketpool service config

#################
# Initial start
#################

echo -e "\n-----------------"
echo "Log out and back in"
echo -e "-----------------\n\n"

echo "Then run 'rocketpool service start'and 'rocketpool wallet init'"

# Commands to run manually
# rocketpool node register
# rocketpool node deposit