# TrueNAS-alerts-pushover
A hacky solution for enabling webhooks via Pushover for alert notification. Uses `midclt call alert.list` to get the alerts and a cronjob on the machine to run the script, but only sends a webhook if the list of alerts has changed.
