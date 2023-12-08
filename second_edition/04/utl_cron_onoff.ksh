#!/bin/ksh

OPTION=$1
CRON_BKUPDIR=$HOME/cron_backups

backup_crontab() {
  typeset TIMESTAMP
  TIMESTAMP=`date '+%y%m%d%H%M%S'`

  crontab -l > ${CRON_BKUPDIR}/crontab.${TIMESTAMP}
  
  if [ $? -gt 0 ]; then
    echo "CRITICAL: Unable to backup crontab."
    exit 1
  fi
}

enable_crontab() {
  typeset LAST_CRONFILE

  LAST_CRONFILE=`ls -1tr ${CRON_BKUPDIR}/crontab.* | tail -1`
  crontab ${LAST_CRONFILE}
}  


# Main program.

if [ "${OPTION}" = "disable" ]; then
  backup_crontab
  crontab -r
  echo "Crontab disabled."
elif [ "${OPTION}" = "enable" ]; then
  enable_crontab
  echo "Crontab enabled."
else
  echo "Usage: $0 [ enable | disable ]"
fi
