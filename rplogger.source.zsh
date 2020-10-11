function rplogger() {
	
	echo -e "$( date ) - $1"
	echo -e "$( date ) - $1" >> $ROCKETCRONLOG

}