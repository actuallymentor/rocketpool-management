source ./rplogger.source.zsh
source ./notify.source.zsh


function logresources() {

	# All in KiB
	echo "Getting memory stats"
	memtotal=$( grep MemTotal /proc/meminfo | grep -Po "[0-9]+" )
	memfree=$( grep MemFree /proc/meminfo | grep -Po "[0-9]+" )
	memutil=$(( $memfree * 100 / $memtotal ))
	swaptotal=$( grep SwapTotal /proc/meminfo | grep -Po "[0-9]+" )
	swapfree=$( grep SwapFree /proc/meminfo | grep -Po "[0-9]+" )
	swaputil=$(( $swapfree * 100 / $swaptotal ))

	# Default log
	echo "Log resources to log"
	rplogger "[info] RAM free: $memutil % of $memtotal KiB, SWAP free: $swaputil % of $swaptotal KiB"

	# Send the status to the logs and push notification
	echo "RAM emergency logging"
	if (( memutil < $RAMWARNINGPERCENT )); then
		rplogger "[RAM] $memutil % free of $(( $memtotal / 1024 / 1024 ))GB"
		notify "Resource Warning" "RAM free: $memutil percent"
	fi

	echo "Swap emergency logging"
	if (( $SWAPWARNINGPERCENT < 50 )); then
		rplogger "[SWAP] $swaputil % free of $(( $swaputil / 1024 / 1024 ))GB"
		notify "Resource Warning" "SWAP free: $swaputil percent"
	fi

	echo "Resources log done"

}