#!/bin/ksh

LOGFILE=/tmp/script.log

msg_print() {
  typeset MSG
  typeset TIMESTAMP

  MSG=$1
  TIMESTAMP=`date '+%Y-%m-%d %H:%M:%S'`
  echo ${MSG}
  echo "${TIMESTAMP}  ${MSG}" >> ${LOGFILE}
}

msg_print "CRITICAL: File is not found! Pls check."

msg_print "Completed job."
