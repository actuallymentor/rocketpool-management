source ./rplogger.source.zsh
source ./notify.source.zsh

function logcpu() {
	idlecounter=0

	export CPUSAMPLESPERMEASUREMENT=20
export CPUSAMPLEDELAYINSECONDS=.5

	for ((i = 0; i < $CPUSAMPLESPERMEASUREMENT; i++)); do
		currentidle=$( top -bn1 | grep -Po "[0-9.]*(?=( id,))" )
		((idlecounter += $currentidle))
		sleep $CPUSAMPLEDELAYINSECONDS
	done

	cpuutil=$( echo "$(( $idlecounter / $CPUSAMPLESPERMEASUREMENT ))" | grep -Po "\d+(?=\.)" | awk '{print 100 - $1}' )

	echo $cpuutil

}


function logresources() {

	# RP Stats
	minipools=$( rocketpool node status | grep -Po "\d+(?=(\ minipool))" )

	# Memory ( all in KiB )
	echo "Getting memory stats"
	memtotal=$( grep MemTotal /proc/meminfo | grep -Po "[0-9]+" )
	memfree=$( grep MemFree /proc/meminfo | grep -Po "[0-9]+" )
	memtaken=$(( $memtotal - $memfree ))
	memfreepercent=$(( $memfree * 100 / $memtotal ))
	memutil=$(( 100 - $memfreepercent ))

	# Swap
	echo "Getting swap stats"
	swaptotal=$( grep SwapTotal /proc/meminfo | grep -Po "[0-9]+" )
	swapfree=$( grep SwapFree /proc/meminfo | grep -Po "[0-9]+" )
	swaptaken=$(( $swaptotal - $swapfree ))
	swapfreepercent=$(( $swapfree * 100 / $swaptotal ))
	swaputil=$(( 100 - $swapfreepercent ))

	# CPU usage
	echo "Getting CPU stats"
	cpuutil=$( logcpu )

	# Pretty representation
	echo "Formulating messages"
	reslog="$memutil%25 RAM | $swaputil%25 SWAP | $cpuutil%25 CPU"
	restable="$memutil% RAM | $swaputil% SWAP | $cpuutil% CPU | $minipools minipools | $(( $memtaken /1024 ))/$(( $memtotal/1024 )) MiB RAM | $(( $swaptaken /1024 ))/$(( $swaptotal/1024 )) MiB SWAP"

	# Default log the resources
	echo "Log resources to log"
	rplogger "[info] $restable"

	# Send the status to the logs and push notification
	echo "Resource emergency logging"
	if (( $memutil > $RAMWARNINGPERCENT || $swaputil > $SWAPWARNINGPERCENT )); then

		# Log with warning tag for easy grepping
		echo "Push and log warning triggered"
		rplogger "[warning] $reslog"
		notify "Rocketpool" $reslog

	fi

	echo "Resources log done"

}