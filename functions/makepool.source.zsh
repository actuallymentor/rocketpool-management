#!/bin/zsh

source "${0:a:h}/rplogger.source.zsh"

function make16ethpool() {
	set timeout -1

	rplogger '[make16ethpool] starting process'
	spawn rocketpool node deposit

	expect "Please choose an amount of ETH to deposit:"

	send -- "2\r"

	expect "Do you want to use the suggested minimum?"

	send -- "y\r"

	rplogger '[make16ethpool] done with process'

	expect eof
}