source ./rplogger.source.zsh
source ./notify.source.zsh

function notifyIf16EthAvailable() {

	echo "Check if 16 ETH is available"
	ethavailable=$( rocketpool node status | grep -Po "([0-9]+)(?=(\.[0-9]+ ETH))" )

	if (( ethavailable > 16 )); then
		rplogger "[notifyIf16EthAvailable] $ethavailable ETH available, sending push"
		notify "$ethavailable ETH in node!" "Go set up a minipool yo"
	fi

	echo "16ETH logger done"

}
