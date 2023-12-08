#!/bin/ksh

HOSTNAME=`hostname`

echo "List of crontab files in ${HOSTNAME} which have been changed in the last 2 days"
echo
find /var/spool/cron/crontabs/* -mtime -2

exit 0
