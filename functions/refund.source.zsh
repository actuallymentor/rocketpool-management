#!/bin/zsh

source "${0:a:h}/rplogger.source.zsh"
echo "${0:a:h}"

function refund() {

	echo "Start refund check"

	# If refund available go for it
	if rocketpool node status | grep -q refund; then
		rplogger "[refund] refund available, triggering refund"
	    echo -e '1\n' | rocketpool minipool refund
	    rplogger "[refund] refund done: $( rocketpool node status | grep refund )"
	else
		echo "No refund available"
		rplogger "[refund] no refund available"
	fi

	echo "End refund check"

}