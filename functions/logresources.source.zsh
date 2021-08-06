#!/bin/zsh

source "${0:a:h}/rplogger.source.zsh"
source "${0:a:h}/notify.source.zsh"

function logcpu() {
	idlecounter=0

	for ((i = 0; i < $CPUSAMPLESPERMEASUREMENT; i++)); do
		currentidle=$( top -bn1 | grep -Po "[0-9.]*(?=( id,))" )
		((idlecounter += $currentidle))
		sleep $CPUSAMPLEDELAYINSECONDS
	done

	cpuutil=$( echo "$(( $idlecounter / $CPUSAMPLESPERMEASUREMENT ))" | grep -Po "\d+(?=\.)" | awk '{print 100 - $1}' )

	echo $cpuutil

}

function logtemp() {
	if which sensors; then
		millidegrees=$( cat /sys/class/thermal/thermal_zone*/temp || 0 )
		degrees=$(( millidegrees / 1000 ))
		echo $degrees
	elif
		echo 0
	fi
}


function logresources() {

	# RP Stats
	export PATH=~/bin/:$PATH
	echo "Getting node stats"
	rpservice=$( rocketpool service version )
	rpstatus=$( rocketpool node status )

	# Minipool data
	minipoolstatus=$( rocketpool minipool status )
	minipools=$( echo $rpstatus | grep -Po "\d+(?=(\ minipool))" )
	staking=$( echo $rpstatus | grep -Po "\d+(?=(\ staking))" )
	activevalidators=$( echo $minipoolstatus | grep -Po "Validator active:( )* yes" | wc -l )
	unseenvalidators=$( echo $minipoolstatus | grep -Po "Validator seen:( )* no" | wc -l )

	# Service data
	rpclientversion=$( echo $rpservice | grep -Po "(?<=client version: ).*$" )
	rpserviceversion=$( echo $rpservice | grep -Po "(?<=service version: ).*$" )

	echo "Node data: $rpstatus"

	# Memory ( all in KiB )
	echo "Getting memory stats"
	memtotal=$( grep MemTotal /proc/meminfo | grep -Po "[0-9]+" )
	memavail=$( grep MemAvailable /proc/meminfo | grep -Po "[0-9]+" )
	memtaken=$(( $memtotal - $memavail ))
	memfreepercent=$(( $memavail * 100 / $memtotal ))
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
	cputemp=$( logtemp )

	# Pretty representation
	echo "Formulating messages"
	reslog="$memutil%25 RAM | $swaputil%25 SWAP | $cpuutil%25 CPU"
	restable="$memutil% RAM | $swaputil% SWAP | $cpuutil% CPU | $cputemp C | $minipools minipools | $staking staking | $activevalidators active | $(( $memtaken /1024 ))/$(( $memtotal/1024 )) MiB RAM | $(( $swaptaken /1024 ))/$(( $swaptotal/1024 )) MiB SWAP"
	csvh='$(date),$memutil,$memtaken,$memtotal,$swaputil,$swaptaken,$swaptotal,$cpuutil,$cputemp,$minipools,$staking,$activevalidators,$unseenvalidators,$rpclientversion,$rpserviceversion'
	csv="$(date),$memutil,$memtaken,$memtotal,$swaputil,$swaptaken,$swaptotal,$cpuutil,$cputemp,$minipools,$staking,$activevalidators,$unseenvalidators,$rpclientversion,$rpserviceversion"

	# Echo csv data for debugging
	echo $csvh
	echo $csv

	# Default log the resources
	echo "Log resources to log"
	rplogger "[info] $restable"
	csvlogger $csvh $csv

	# Send the status to the logs and push notification
	echo "Resource emergency logging"
	if (( $memutil > $RAMWARNINGPERCENT || $swaputil > $SWAPWARNINGPERCENT || $cpuutil > $CPUWARNINGPERCENT )); then

		# Log with warning tag for easy grepping
		echo "Push and log warning triggered"
		rplogger "[warning] $reslog"
		notify "Rocketpool" $reslog

	fi

	echo "Resources log done"

}