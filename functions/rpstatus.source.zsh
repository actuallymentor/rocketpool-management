#!/bin/zsh

function line() {
	if [[ -v 1 ]]; then
		echo -e "\n--------------------"
	else
		echo "--------------------"
	fi
}
function rpstatus() {

	line 1
	echo -e "Validator statuses:"
	line

	rocketpool minipool status | grep seen:
	rocketpool minipool status | grep active:

	line 1
	echo "Refund status:"
	line

	if rocketpool node status | grep -q refund; then
		    echo -e '1\n' | rocketpool minipool refund
	else
		echo "No refund available"
	fi

	line 1
	echo 'Wallet status"'
	line

	rocketpool node status | grep balance

}

function eth2SyncStatus() {
	eth2eta=$( rocketpool service logs eth2 | grep -Po -m 1 "(?<=estimated time remaining )[0-9hms]+" )
	echo "ETH2 ETA: $eth2eta"
}