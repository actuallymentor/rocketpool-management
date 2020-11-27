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
sudo ufw allow 9000/tcp comment 'Lighthouse node'
sudo ufw allow 9000/udp comment 'Lighthouse node'

sudo ufw enable

###################
# Rocketpool setup
###################

cd
curl -L https://github.com/rocket-pool/smartnode-install/releases/latest/download/rocketpool-cli-linux-amd64 --create-dirs -o ~/bin/rocketpool && chmod +x ~/bin/rocketpool

echo "export PATH=~/bin/:$PATH" >> ~/.zshrc
source ~/.zshrc

rocketpool service install
source ~/.zshrc

rocketpool service config

#########################
# Beta-specific configs
#########################
# Run prysm in efficient mode, no longer needed, leaving for reference
# sed -i 's/binary/binary --blst --p2p-max-peers 75/g' ~/.rocketpool/chains/eth2/start-beacon.sh
# sed -i 's/binary/binary --blst /g' ~/.rocketpool/chains/eth2/start-validator.sh

# Set graffiti for guildwarz
# Note: this ended, leaving it here for reference
# sed -i 's/--graffiti "$GRAFFITI"/--graffiti "guildwarz-rocket-pool"/g' ~/.rocketpool/chains/eth2/start-validator.sh

#################
# Initial start
#################

rocketpool service start

# Get some stats to verify we are good
rocketpool service stats

# User interaction
rocketpool wallet init

# Faucet doesn't seem to work
# rocketpool faucet withdraw eth
# Should be showing balance of 33eth
# rocketpool node status

rocketpool node register
rocketpool node deposit