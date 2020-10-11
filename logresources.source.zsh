source ./rplogger.source.zsh
source ./notify.source.zsh


function logresources() {

	# All in KiB
	memtotal=$( grep MemTotal /proc/meminfo | grep -Po "[0-9]+" )
	memfree=$( grep MemFree /proc/meminfo | grep -Po "[0-9]+" )
	memutil=$(( $memfree * 100 / $memtotal ))
	swaptotal=$( grep SwapTotal /proc/meminfo | grep -Po "[0-9]+" )
	swapfree=$( grep SwapFree /proc/meminfo | grep -Po "[0-9]+" )
	swaputil=$(( $swapfree * 100 / $swaptotal ))

	# Send the status to the logs and push notification
	if (( memutil < $RAMWARNINGPERCENT )); then
		rplogger "[RAM] $memutil % of $(( $memtotal / 1024 / 1024 ))GB"
		notify "Resource Warning" "RAM usage $memutil percent"
	fi

	if (( $SWAPWARNINGPERCENT < 50 )); then
		rplogger "[SWAP] $swaputil % of $(( $swaputil / 1024 / 1024 ))GB"
		notify "Resource Warning" "SWAP usage $swaputil percent"
	fi

}