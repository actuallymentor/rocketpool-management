function refund() {

	# If refund available go for it
	if rocketpool node status | grep -q refund; then
	    echo -e '1\n' | rocketpool minipool refund
	else
		echo "No refund available"
	fi

}

refund