# Setup

# Create new user
username="rocketman"
adduser $username
su - $username 

cd
curl -L https://github.com/rocket-pool/smartnode-install/releases/latest/download/rocketpool-cli-linux-amd64 --create-dirs -o ~/bin/rocketpool && chmod +x ~/bin/rocketpool

echo "export PATH=~/bin/:$PATH" >> ~/.zshrc
source ~/.zshrc

rocketpool service install
source ~/.zshrc

rocketpool service config

# Run prysm in efficient mode
sed -i 's/binary/binary --blst --p2p-max-peers 75/g' ~/.rocketpool/chains/eth2/start-beacon.sh
sed -i 's/binary/binary --blst /g' ~/.rocketpool/chains/eth2/start-validator.sh

# Set graffiti for guildwarz
sed -i 's/--graffiti "$GRAFFITI"/--graffiti "guildwarz-rocket-pool"/g' ~/.rocketpool/chains/eth2/start-validator.sh

rocketpool service start

# Get some stats to verify we are good
rocketpool service stats

# User interaction
rocketpool wallet init
rocketpool faucet withdraw eth

# Should be showing balance of 33eth
rocketpool node status

rocketpool node register
rocketpool node deposit

# Optional if you want to automate minipool creation
apt install -y expect