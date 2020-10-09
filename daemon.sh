source ./.env

while true
do
	zsh ./refund.sh
	zsh ./notifier.sh
	sleep $DAEMONINTERVAL
done