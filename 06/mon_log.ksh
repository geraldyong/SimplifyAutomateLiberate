#!/bin/ksh

# Expression to Capture
EXPR='error|fatal|warn|fail'
# Expression to Exclude
NEXPR='Error 3113|user.info|Authentication'

# You should source these from a separate config file.
LOG=app.log
SCRIPTS_TMP_DIR=tmp
SCRIPT_NAME=`basename $0 ".ksh"`

CUR_CONTENT=${SCRIPTS_TMP_DIR}/${SCRIPT_NAME}_cache.new
OLD_CONTENT=${SCRIPTS_TMP_DIR}/${SCRIPT_NAME}_cache.old
PAGE_EMAIL_LOG=${SCRIPTS_TMP_DIR}/${SCRIPT_NAME}_msg.log
TAIL_COUNT=500
>${CUR_CONTENT}
>${PAGE_EMAIL_LOG}

# Getting the content from respective log files to the temporary files
get_content() {
  typeset CONTENT_FILE
  typeset LOG_FILE

  CONTENT_FILE=$1
  LOG_FILE=$2

  tail -${TAIL_COUNT} $LOG_FILE > ${CONTENT_FILE}
}

# Compare the current cache with the previous cache, and save the differences into the log file.
find_difference() {
  diff ${CUR_CONTENT} ${OLD_CONTENT} | grep '^<'| sed "s/^</CRITICAL: /" | egrep -vi "${NEXPR}" | egrep -i "${EXPR}" > ${PAGE_EMAIL_LOG}
}

# Main Program

# Check if the previous cache exists. If not, create it and exit.
if [ -e ${LOG} ]; then
  if [ ! -e ${OLD_CONTENT} ]; then
    get_content ${OLD_CONTENT} ${LOG}
    exit 0
  fi
fi

# Gets the current cache.
get_content ${CUR_CONTENT} ${LOG}
find_difference

# Checks if any more messages after filtering and flood control.
if [ -s ${PAGE_EMAIL_LOG} ]; then
  # Run notification script and provide it with the list of messages.
  cat ${PAGE_EMAIL_LOG}
fi

# Replace old cache with current cache.
cp -p ${CUR_CONTENT} ${OLD_CONTENT}
