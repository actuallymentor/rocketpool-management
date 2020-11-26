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