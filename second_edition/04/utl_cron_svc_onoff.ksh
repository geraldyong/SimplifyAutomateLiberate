#!/bin/ksh

SERVICE_NAME=$1
SERVICE_OPT=$2

backup_crontab() {
  typeset CRONFILE
  CRONFILE=$1

  crontab -l > ${CRONFILE}
}

activate_crontab() {
  typeset CRONFILE
  CRONFILE=$1

  crontab ${CRONFILE}
}

update_cronsvc() {
  typeset SVCNAME
  typeset OPTION
  typeset TIMESTAMP
  typeset CRON_BKUPFILE
  typeset CRON_NEWFILE

  SVCNAME=$1
  OPTION=$2
  TIMESTAMP=`date '+%y%m%d-%H%M%S'`
  CRON_BKUPFILE=$HOME/cron_backups/crontab.${TIMESTAMP}
  CRON_NEWFILE=$HOME/cron_backups/crontab.${TIMESTAMP}.new

  # Back up existing crontab.
  backup_crontab ${CRON_BKUPFILE}

  # Create new crontab file.
  if [ "$OPTION" = "enable" ]; then
    cat ${CRON_BKUPFILE} | sed "s/#\(.*${SVCNAME}.*\)/\1/" > ${CRON_NEWFILE}
  elif [ "$OPTION" = "disable" ]; then
    cat ${CRON_BKUPFILE} | sed "s/.*${SVCNAME}/#&/" > ${CRON_NEWFILE}
  else
    echo "CRITICAL: Unrecognised option ${OPTION}. Pls check."
    return 1
  fi

  # Activate new crontab.
  activate_crontab ${CRON_NEWFILE}
}


# Main Program.
if [ ! "${SERVICE_NAME}" ] || [ ! "${SERVICE_OPT}" ]; then
  echo "Usage: $0 { service_key } { enable | disable }"
else
  update_cronsvc ${SERVICE_NAME} ${SERVICE_OPT}
  crontab -l | egrep ${SERVICE_NAME}
fi
