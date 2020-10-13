#!/bin/zsh

source "${0:a:h}/rplogger.source.zsh"

function make16ethpool() {

	rplogger '[make16ethpool] starting process'
	
	expect ./minipool.16.expect

	rplogger '[make16ethpool] done with process'

	
}