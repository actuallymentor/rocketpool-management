# Rocketpool management

These are the functions I use to set up and manage my Rocketpool node.

Assumptions:

- You are on Ubuntu 20
- You're using Geth, Prysm and Teku

## Features

- A setup script to inspire your own workflow
    + Not using `zsh` yet? Check out my [vps setup script]( https://github.com/actuallymentor/vps-setup-ssh-zsh-pretty )
- Send you a push notification if your RAM or CPU is overused
- Keep a `.csv` log of your resources
- Automatically withdraw refunds from minipools so you can scale up
- Send a push notification if you have over `16 ETH` available

## Requirements

- An `.env` file with environment vars as documented in `.env.example`
- Using `zsh` as your shell, see [oh my ZSH]( https://ohmyz.sh/ )
- *Optional: A [Pushover]( https://pushover.net/ ) account*

## Usage

Clone this repository:

`git clone https://github.com/actuallymentor/rocketpool-management.git && cd rocketpool-management`

Copy the example `.env` and edit it to suit your needs.

`cp .env.example .env && nano .env`

Install a cronjob that calls `cron.zsh`, for example:

`0,15,30,45 * * * * cd ~/rocketpool-management/ && zsh cron.zsh`

## Faucets

- https://prylabs.net/participate 
- https://faucet.goerli.mudit.blog/ 
- https://goerli-faucet.slock.it/ 