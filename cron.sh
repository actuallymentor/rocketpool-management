source ./.env

while true
do
	zsh ./refund.sh
	zsh ./notifier.sh
	sleep $CRONINTERVAL
done