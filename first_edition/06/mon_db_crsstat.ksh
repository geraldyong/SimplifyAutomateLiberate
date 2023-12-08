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
  CACHE_FILE=$1

  ${CRSSTAT} > ${CACHE_FILE}
}

# Compare the current cache with the previous cache, and save the differences into the log file.
compare_states() {
  diff ${CUR_CONTENT} ${OLD_CONTENT} | grep '^<'| sed "s/^<//" > ${PAGE_EMAIL_LOG}
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
