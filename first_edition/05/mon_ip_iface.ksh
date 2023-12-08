#!/bin/ksh

SCRIPT_NAME=`basename $0`
CACHE_DIR=./tmp
CACHE_FILE=${CACHE_DIR}/${SCRIPT_NAME}.cache
TMP_FILE=${CACHE_DIR}/${SCRIPT_NAME}.tmp
WARN_THRES=50
CRIT_THRES=100
OS=`uname -s`

# Determine the netstat command to use.
if [ "$OS" = "SunOS" ]; then
  netstat -in | awk '{ print $1,$5,$6,$7,$8 }' | tail +2 | grep -v "^ " > ${TMP_FILE}
elif [ "$OS"  = "Linux" ]; then
  netstat -in | awk '{ print $1,$4,$5,$8,$9 }' | tail -n 2 > ${TMP_FILE}
else
  echo "CRITICAL: Your OS $OS is not supported by this script."
  exit 1
fi


# If cache file exists, loop through each interface and determine 
# if there are problems.
if [ -e ${CACHE_FILE} ]; then
  cat ${TMP_FILE} | while read i; do
    IFACE_NAME=`echo $i | awk '{ print $1 }'`
    CURR_IN_TOT=`echo $i | awk '{ print $2 }'`
    CURR_IN_ERR=`echo $i | awk '{ print $3 }'`
    CURR_OUT_TOT=`echo $i | awk '{ print $4 }'`
    CURR_OUT_ERR=`echo $i | awk '{ print $5 }'`

    # Obtain the statistics from previous cache.
    PREV_IFACE=`cat ${CACHE_FILE} | egrep "^${IFACE_NAME}"`
    PREV_IN_TOT=`echo ${PREV_IFACE} | awk '{ print $2 }'`
    PREV_IN_ERR=`echo ${PREV_IFACE} | awk '{ print $3 }'`
    PREV_OUT_TOT=`echo ${PREV_IFACE} | awk '{ print $4 }'`
    PREV_OUT_ERR=`echo ${PREV_IFACE} | awk '{ print $5 }'`

    # Compare current and previous statistics.
    DIFF_IN_ERR=$(( CURR_IN_ERR-PREV_IN_ERR ))
    DIFF_OUT_ERR=$(( CURR_OUT_ERR-PREV_OUT_ERR ))

    if [ ${DIFF_IN_ERR} -ge ${CRIT_THRES} ]; then
      echo "CRITICAL: NW IFace ${IFACE_NAME} has ${DIFF_IN_ERR} new incoming pkt errors. Pls check."
    elif [ ${DIFF_IN_ERR} -ge ${WARN_THRES} ] && [ ${DIFF_IN_ERR} -lt ${CRIT_THRES} ]; then
      echo "WARNING: NW IFace ${IFACE_NAME} has ${DIFF_IN_ERR} new incoming pkt errors. Pls check."
    fi

    if [ ${DIFF_OUT_ERR} -ge ${CRIT_THRES} ]; then
      echo "CRITICAL: NW IFace ${IFACE_NAME} has ${DIFF_OUT_ERR} new outgoing pkt errors. Pls check."
    elif [ ${DIFF_OUT_ERR} -ge ${WARN_THRES} ] && [ ${DIFF_OUT_ERR} -lt ${CRIT_THRES} ]; then
      echo "WARNING: NW IFace ${IFACE_NAME} has ${DIFF_OUT_ERR} new outgoing pkt errors. Pls check."
    fi
  done
fi

# Update cache file.
mv ${TMP_FILE} ${CACHE_FILE}
