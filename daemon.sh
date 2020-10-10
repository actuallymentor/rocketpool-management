source ./.env

while true
do
	zsh ./cron.zsh
	sleep $DAEMONINTERVAL
done