source ./rplogger.source.zsh
source ./notify.source.zsh


function logresources() {

	# All in KiB
	echo "Getting memory stats"
	memtotal=$( grep MemTotal /proc/meminfo | grep -Po "[0-9]+" )
	memfree=$( grep MemFree /proc/meminfo | grep -Po "[0-9]+" )
	memfreepercent=$(( $memfree * 100 / $memtotal ))
	memutil=$(( 100 - $memfreepercent ))

	swaptotal=$( grep SwapTotal /proc/meminfo | grep -Po "[0-9]+" )
	swapfree=$( grep SwapFree /proc/meminfo | grep -Po "[0-9]+" )
	swapfreepercent=$(( $swapfree * 100 / $swaptotal ))
	swaputil=$(( 100 - $swapfreepercent ))

	# Default log
	echo "Log resources to log"
	rplogger "[info] $memutil% RAM ($memfree/$memtotal), $swaputil% SWAP ($swapfree/$swaptotal)"

	# Send the status to the logs and push notification
	echo "RAM emergency logging"
	if (( memutil < $RAMWARNINGPERCENT )); then
		warning="[RAM] Warning: $memutil% utilisation ($memfree/$memtotal), SWAP: $swaputil%"
		rplogger $warning
		notify "Rocketpool Warning" $warning
	fi

	echo "Swap emergency logging"
	if (( $SWAPWARNINGPERCENT < 50 )); then
		warning="[SWAP] Warning: $swaputil% utilisation ($swapfree/$swaptotal)"
		rplogger $warning
		notify "Resource Warning" $warning
	fi

	echo "Resources log done"

}