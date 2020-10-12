# update script if it was updated
git pull

source ./.env
source ./refund.source.zsh
source ./notifyIf16EthAvailable.source.zsh
source ./rplogger.source.zsh
source ./logresources.source.zsh

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