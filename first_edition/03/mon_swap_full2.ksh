#!/bin/ksh

WARN_THRES=75
CRIT_THRES=90
OS=`uname -s`

chk_user_root() {
  USERID=`id | cut -f2 -d'(' | cut -f1 -d')'`

  if [ ! "${USERID}" = "root" ]; then
    echo "CRITICAL: You must be root to run this script."
    exit 1
  fi
}

chk_swap_full() {
  typeset SWAPCMD
  typeset KB_TOTAL
  typeset KB_FREE
  typeset PCT_USED

  # Determine swap space. 
  if [ "${OS}" = "Linux" ]; then
    SWAPCMD=`swapon -s | tail +2 | awk '{ total+=$4; free+=$5 } END { print total,free}'`
  else
    SWAPCMD=`swap -l | tail +2 | awk '{ total+=$4; free+=$5 } END { print total,free}'`
  fi

  # Reformats and reads df -k output.
  KB_TOTAL=`echo ${SWAPCMD} | awk '{ print $1 }'`
  KB_FREE=`echo ${SWAPCMD} | awk '{ print $2 }'`
  PCT_USED=`echo "(${KB_TOTAL}-${KB_FREE})*100/${KB_TOTAL}" | bc`

  # Check if the swap used meets warning or critical thresholds.
  if [ ${PCT_USED} -ge ${WARN_THRES} ] && [ ${PCT_USED} -lt ${CRIT_THRES} ]; then
    echo "WARNING: Swap space has ${KB_FREE}kb avail and is ${PCT_USED}% full!"
  elif [ ${PCT_USED} -ge ${CRIT_THRES} ]; then
    echo "CRITICAL: Swap space has ${KB_FREE}kb avail and is ${PCT_USED}% full!"
  fi
}


# Main program.
chk_user_root
chk_swap_full
