source ./rplogger.source.zsh
source ./notify.source.zsh


function logresources() {

	# All in KiB

	# Memory
	echo "Getting memory stats"
	memtotal=$( grep MemTotal /proc/meminfo | grep -Po "[0-9]+" )
	memfree=$( grep MemFree /proc/meminfo | grep -Po "[0-9]+" )
	memfreepercent=$(( $memfree * 100 / $memtotal ))
	memutil=$(( 100 - $memfreepercent ))

	# Swap
	swaptotal=$( grep SwapTotal /proc/meminfo | grep -Po "[0-9]+" )
	swapfree=$( grep SwapFree /proc/meminfo | grep -Po "[0-9]+" )
	swapfreepercent=$(( $swapfree * 100 / $swaptotal ))
	swaputil=$(( 100 - $swapfreepercent ))

	# Pretty representation
	memlog="$memutil% RAM / $swaputil% SWAP"
	memtable="$memutil% RAM | $swaputil% SWAP | $(( $memfree /2014 ))/$(( $memtotal/1024 )) MiB RAM | $(( $swapfree /2014 ))/$(( $swaptotal/1024 )) MiB SWAP"

	# Default log the resources
	echo "Log resources to log"
	rplogger "[info] $memtable"

	# Send the status to the logs and push notification
	echo "Resource emergency logging"
	if (( $memutil > $RAMWARNINGPERCENT || $swaputil > $SWAPWARNINGPERCENT )); then

		# Log with warning tag for easy grepping
		echo "Warning triggered"
		rplogger "[warning] $memlog"
		notify "Rocketpool" $memlog

	fi

	echo "Resources log done"

}