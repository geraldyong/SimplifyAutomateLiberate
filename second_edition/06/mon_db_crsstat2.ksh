#!/bin/ksh
 
# You should source these in a separate config file.
CRSSTAT=./crs_stat
SCRIPTS_TMP_DIR=tmp
SCRIPT_NAME=`basename $0 ".ksh"`
 
CUR_CONTENT=${SCRIPTS_TMP_DIR}/${SCRIPT_NAME}_cache.new
OLD_CONTENT=${SCRIPTS_TMP_DIR}/${SCRIPT_NAME}_cache.old
PAGE_EMAIL_LOG=${SCRIPTS_TMP_DIR}/${SCRIPT_NAME}_msg.log
>${CUR_CONTENT}
>${PAGE_EMAIL_LOG}

# Getting the content from respective log files to the cache files.
get_curr_state() { 
  typeset CACHE_FILE
  typeset SVC_NAME
  typeset EXP_STATE
  typeset CUR_STATE
  typeset ACTIVE_ON
  CACHE_FILE=$1

  ${CRSSTAT} | egrep -v "^HA Resource|^\-\-" | tr -s ' ' ',' | while read i; do
    SVC_NAME=`echo $i | cut -f1 -d','`
    EXP_STATE=`echo $i | cut -f2 -d','`
    CUR_STATE=`echo $i | cut -f3 -d',' | cut -f1 -d' '`
    ACTIVE_ON=`echo $i | cut -f5 -d','`

    echo "${SVC_NAME},${EXP_STATE},${CUR_STATE},${ACTIVE_ON}" >> ${CACHE_FILE}
  done
}

# Compare the current cache with the previous cache, and save the differences into the log file.
compare_states() {
  # If no difference, ignore and return.
  if [ `diff ${CUR_CONTENT} ${OLD_CONTENT} | wc -l | tr -d ' '` -eq 0 ]; then
    return 0;
  fi

  cat ${CUR_CONTENT} | while read i; do
    # xxx_C means current state for xxx
    # xxx_P means previous state for xxx

    SVC_NAME_C=`echo $i | cut -f1 -d','`
    EXP_STATE_C=`echo $i | cut -f2 -d','`
    CUR_STATE_C=`echo $i | cut -f3 -d','`
    ACTIVE_ON_C=`echo $i | cut -f4 -d','`
    CRS_STAT_P=`cat ${OLD_CONTENT} | grep ^${SVC_NAME_C}`
   
    if [ ! "${CRS_STAT_P}" ]; then
      echo "CRITICAL: Service ${SVC_NAME_C} seems to be a new service, pls check." 
    else
      EXP_STATE_P=`echo ${CRS_STAT_P} | cut -f2 -d','`
      CUR_STATE_P=`echo ${CRS_STAT_P} | cut -f3 -d','`

      # Check if any change.
      if [ "${EXP_STATE_P}" = "${EXP_STATE_C}" ] && [ "${CUR_STATE_P}" = "${CUR_STATE_C}" ]; then
        echo "Service ${SVC_NAME_C} ok"
      elif [ "${CUR_STATE_P}" != "${CUR_STATE_C}" ]; then
        echo "CRITICAL: Service ${SVC_NAME_C} curr state is now ${CUR_STATE_C} (previously ${CUR_STATE_P})." >> ${PAGE_EMAIL_LOG}
      elif [ "${EXP_STATE_P}" != "${EXP_STATE_C}" ]; then
        echo "CRITICAL: Service ${SVC_NAME_C} expected state is now ${EXP_STATE_C} (previously ${EXP_STATE_P})." >> ${PAGE_EMAIL_LOG}
      fi
    fi
  done

  # Update the cache.
  cp -p ${CUR_CONTENT} ${OLD_CONTENT}
} 
# Main Program
 
# Check if the previous cache exists. If not, create it and exit.
if [ ! -e ${OLD_CONTENT} ]; then
  get_curr_state ${OLD_CONTENT}
  exit 0
fi
 
# Gets the current cache.
get_curr_state ${CUR_CONTENT}
compare_states
 
# Checks if any more messages after filtering and flood control.
if [ -s ${PAGE_EMAIL_LOG} ]; then
  # Run notification script and provide it with the list of messages.
  cat ${PAGE_EMAIL_LOG}
fi
 
# Replace old cache with current cache.
cp -p ${CUR_CONTENT} ${OLD_CONTENT}
