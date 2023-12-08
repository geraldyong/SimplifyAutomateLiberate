#!/bin/ksh
#
# Copies a local file to a remote location.

LOCAL_FILE=/opt/app/log.txt
DEST_CONN=john@server1
DEST_PATH=/opt/app/logs
SCP=/usr/bin/scp

echo "Performing scp of ${LOCAL_FILE} to ${DEST_CONN}:${DEST_PATH}"
${SCP} -p -q ${LOCAL_FILE} ${DEST_CONN}:${DEST_PATH}

if [ $? -ne 0 ]; then
  echo "CRITICAL: Failed to scp ${LOCAL_FILE} to dest ${DEST_CONN}."
  exit 1
fi

exit 0
