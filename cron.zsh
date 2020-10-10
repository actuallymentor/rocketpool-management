source ./.env
source ./refund.source.zsh
source ./notifyIf16EthAvailable.source.zsh
source ./rplogger.source.zsh

rplogger "[cron] start"
# Refund if available
refund | logger -t rocketcron

# notify if 16 eth after refund
notifyIf16EthAvailable | logger -t rocketcron

rplogger "[cron] done"