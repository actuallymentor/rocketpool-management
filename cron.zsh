# update script if it was updated
git pull

source "${0:a:h}/.env"
source "${0:a:h}/functions/refund.source.zsh"
source "${0:a:h}/functions/notifyIf16EthAvailable.source.zsh"
source "${0:a:h}/functions/rplogger.source.zsh"
source "${0:a:h}/functions/logresources.source.zsh"

echo "Cron started"

# Log and notify resources
logresources

# Log
rplogger "[cron] start"
logger -t rocketcron "start cron, logging to $ROCKETCRONLOG, last entry: $( tail -n 1 $ROCKETCRONLOG )"

# Refund if available
if [[ -v AUTO_REFUND ]]; then
	refund | logger -t rocketcron
fi

# notify if 16 eth after refund
if [[ -v NOTIFY_NEW_MINIPOOL ]]; then
	notifyIf16EthAvailable | logger -t rocketcron
fi

rplogger "[cron] done"

logger -t rocketcron "done"

echo "Cron done"