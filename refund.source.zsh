source ./logger.source.zsh

function refund() {

	# If refund available go for it
	if rocketpool node status | grep -q refund; then
		logger "[refund] refund available, triggering refund"
	    echo -e '1\n' | rocketpool minipool refund
	    logger "[refund] refund done: $( rocketpool node status | grep refund )"
	else
		echo "No refund available"
		logger "[refund] no refund available"
	fi

}