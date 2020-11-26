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

# Set zsh params for rocketman
chsh $username -s $( which zsh )
cp ~/.zshrc "/home/$username/"

# Log in as rocketman
su - $username 
