#!/bin/bash
PUSHOVER_USER="REDACTED"
PUSHOVER_TOKEN="REDACTED"
LOG=alerts.log
# Get alert list
#ALERTS=$(midclt call alert.list | jq -r '.[] | "\(.level): \(.formatted)"')
# Get alert list, FILTER LOG LEVELS, Print log level and formatted warning
#ALERTS=$(midclt call alert.list | jq -r '.[] | select(.level == "WARNING" or .level == "INFO") | "\(.level): \(.formatted)\t\(.uuid)"')
# Get alert list, filter out INFO
ALERTS=$(midclt call alert.list | jq -r '.[] | select(.level != "INFO") | "\(.level): \(.formatted)"')

ALERTS_MD5=$(echo "$ALERTS" | md5sum | awk '{print $1}')

# If LOG don't exist: generate alerts.log and send alerts
if  [[ ! -s "$LOG"  ]]; then
    echo "$ALERTS" > $LOG
    curl -s \
        --form-string "token=$PUSHOVER_TOKEN" \
        --form-string "user=$PUSHOVER_USER" \
        --form-string "message=$ALERTS" \
        https://api.pushover.net/1/messages.json
fi

LOG_MD5=$(cat $LOG | md5sum | awk '{print $1}')
#If LOG and ALERTS  differ, send alerts and overwrite LOG
if [[ "$LOG_MD5" != "$ALERTS_MD5" ]]; then
    echo "$ALERTS" > $LOG
    curl -s \
        --form-string "token=$PUSHOVER_TOKEN" \
        --form-string "user=$PUSHOVER_USER" \
        --form-string "message=$ALERTS" \
        https://api.pushover.net/1/messages.json
fi
