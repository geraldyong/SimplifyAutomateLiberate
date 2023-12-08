#!/bin/ksh

SCRIPT_NAME=`basename $0`

TMP_FILE=${SCRIPT_NAME}_`date '+%d%m%y%H%M%S'`.tmp
>${TMP_FILE}
echo "Generated ${TMP_FILE}."
rm -f ${TMP_FILE}

TMP_FILE=`mktemp -t ${SCRIPT_NAME}_XXXXXXXXXXXX.tmp`
echo "Generated ${TMP_FILE}."
rm -f ${TMP_FILE}

PID=$$
TMP_FILE=${SCRIPT_NAME}_${PID}.tmp
>${TMP_FILE}
echo "Generated ${TMP_FILE}."
rm -f ${TMP_FILE}
