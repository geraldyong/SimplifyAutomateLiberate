#!/bin/ksh

WARN_THRES=5
CRIT_THRES=10

chk_swap_full() {
  typeset KB_TOTAL
  typeset KB_FREE
  typeset PCT_USED

  # Determine swap space. 
  SWAPCMD=`swap -l | tail +2 | awk '{ total+=$4; free+=$5 } END { print total,free}'`

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
chk_swap_full
