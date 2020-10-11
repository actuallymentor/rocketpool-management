function notify() {

	curl -f -X POST -d "token=${PUSHOVERAPITOKEN}&user=${PUSHOVERUSER}&title=$1&message=$2&url=&priority=1" https://api.pushover.net/1/messages.json

}