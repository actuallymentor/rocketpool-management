# update script if it was updated
git pull

echo "${0:a:h}"

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
refund | logger -t rocketcron

# notify if 16 eth after refund
# notifyIf16EthAvailable | logger -t rocketcron

rplogger "[cron] done"

logger -t rocketcron "done"

echo "Cron done"