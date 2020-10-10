source ./rplogger.source.zsh

function notify() {

	curl -f -X POST -d "token=${PUSHOVERAPITOKEN}&user=${PUSHOVERUSER}&title=$1&message=$2&url=&priority=1" https://api.pushover.net/1/messages.json

}

function notifyIf16EthAvailable() {

	ethavailable=$( rocketpool node status | grep -Po "([0-9][0-9])(?=(\.[0-9][0-9] ETH))" )

	if (( ethavailable > 16 )); then
		rplogger "[notifyIf16EthAvailable] 16 ETH available, sending push"
		notify "Over 16 ETH in node!" "Go set up a minipool yo"
	fi

}
