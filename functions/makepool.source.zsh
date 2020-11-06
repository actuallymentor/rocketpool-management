#!/bin/zsh

source "${0:a:h}/rplogger.source.zsh"

function make16ethpool() {

	rplogger '[make16ethpool] starting process'
	
	# Since 0.0.7 this is no longer needed
	# ${0:a:h} is different at run and source, hence the path selector
	# expect "${0:a:h}/functions/minipool.16.expect"
	depositlog=$( rocketpool node deposit -a 16 -f 'auto' | tr -d '\n' )

	rplogger "[make16ethpool] $depositlog"

	rplogger '[make16ethpool] done with process'

	
}
