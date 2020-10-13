#!/bin/zsh
echo "${0:a:h}"
function rplogger() {
	
	echo "${0:a:h}"
	echo -e "$( date ) - $1"
	echo -e "$( date ) - $1" >> $ROCKETCRONLOG

}

function csvlogger() {

	# $1 is header, $2 is data
	if [[ ! -a $ROCKETCSVLOG ]]; then
		echo -e "$( date ) - CSV does not yet exist, adding header to $ROCKETCSVLOG"
		echo -e $1 >> $ROCKETCSVLOG
	fi

	# Add data to csv log
	echo -e "$( date ) - adding csv data:  $2"
	echo -e $2 >> $ROCKETCSVLOG

}
