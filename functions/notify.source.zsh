#!/bin/zsh

function notify() {

	if [[ -v SEND_PUSH_NOTIFICATIONS ]]; then
		echo "Sending $1 $2"
		echo "Request: curl -f -X POST -d \"token=${PUSHOVERAPITOKEN}&user=${PUSHOVERUSER}&title=$1&message=$2&url=&priority=1\" https://api.pushover.net/1/messages.json"
		curl -f -X POST -d "token=${PUSHOVERAPITOKEN}&user=${PUSHOVERUSER}&title=$1&message=$2&url=&priority=1" https://api.pushover.net/1/messages.json
	fi
	

}