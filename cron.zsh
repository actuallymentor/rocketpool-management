source ./.env
source ./refund.source.zsh
source ./notifyIf16EthAvailable.source.zsh
source ./logger.source.zsh

logger "[cron] start"
# Refund if available
refund

# notify if 16 eth after refund
notifyIf16EthAvailable

logger "[cron] done"