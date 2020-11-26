echo -e "Did you set up your basic VPS config?\nIf not, this is good inspiration: https://github.com/actuallymentor/vps-setup-ssh-zsh-pretty"
read -p "Press any key to continue rocketpool setup"

####################
# Security settings
####################

# Go Ethereum: https://geth.ethereum.org/docs/interface/private-network#setting-up-networking
ufw allow 30303:30305/tcp comment 'Go Ethereum'
ufw allow 30303:30305/udp comment 'Go Ethereum'

# Teku port number is coincidence https://gist.github.com/Larrypcdotcom/fcd4e79c2cf02ce37ec6ed9797beca2c#ports
ufw allow 9001/tcp comment 'Roketpool arbitrary default port'
ufw allow 9001/udp comment 'Roketpool arbitrary default port'

# Prysm: https://docs.prylabs.network/docs/prysm-usage/p2p-host-ip/#incoming-p2p-connection-prerequisites
ufw allow 13000/tcp comment 'Prysm node'
ufw allow 13000/udp comment 'Prysm node'

# Lighthouse: https://lighthouse-book.sigmaprime.io/advanced_networking.html
ufw allow 9000/tcp comment 'Lighthouse node'
ufw allow 9000/udp comment 'Lighthouse node'

ufw enable

################
# User setup
################

# Create new user
username="rocketman"
adduser $username

# Deny user SSH access
echo "DenyUsers $username" >> /etc/ssh/sshd_config
su - $username 

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

##################
# OPTIONAL
#################

# Optional if you want to automate minipool creation, functions/minipool.16.expect
apt install -y expect