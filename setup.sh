# Setup
cd
curl -L https://github.com/rocket-pool/smartnode-install/releases/latest/download/rocketpool-cli-linux-amd64 --create-dirs -o ~/bin/rocketpool && chmod +x ~/bin/rocketpool

echo "export PATH=~/bin/:$PATH" >> ~/.zshrc
source ~/.zshrc

rocketpool service install
source ~/.zshrc

rocketpool service config
rocketpool service start
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