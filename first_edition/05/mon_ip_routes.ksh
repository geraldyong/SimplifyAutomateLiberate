#!/bin/ksh

SCRIPT_NAME=`basename $0`
CACHE_DIR=./tmp
CACHE_FILE=${CACHE_DIR}/${SCRIPT_NAME}.cache
TMP_FILE=${CACHE_DIR}/${SCRIPT_NAME}.tmp
WARN_THRES=4
OS=`uname -s`

# Determine the netstat command to use.
if [ "$OS" = "SunOS" ]; then
  netstat -rnv | awk '{ print $1,$2,$3,$4 }' | tail +5 | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n  > ${TMP_FILE}
elif [ "$OS"  = "Linux" ]; then
  netstat -rn | awk '{ print $1,$2,$3,$8 }' | tail -n 1 | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n > ${TMP_FILE}
else
  echo "CRITICAL: Your OS $OS is not supported by this script."
  exit 1
fi


# If cache file exists, loop through each interface and determine
# if there are problems.
if [ -e ${CACHE_FILE} ]; then
  ROUTE_DIFF=`diff ${TMP_FILE} ${CACHE_FILE} | egrep "^<|^>" | wc -l | tr -d ' '`

  # If more than WARN_THRES changes, print just one message.
  # Otherwise, print out each change.
  if [ ${ROUTE_DIFF} -gt ${WARN_THRES} ]; then
    echo "CRITICAL: ${ROUTE_DIFF} route changes (> warn thres ${WARN_THRES}) detected. Pls check."
  else
    diff ${TMP_FILE} ${CACHE_FILE} | sed "s/^</ADD/;s/^>/DEL/" | egrep "^ADD|^DEL" | while read i; do
      ROUTE_OP=`echo $i | awk '{ print $1 }'`
      ROUTE_NW=`echo $i | cut -f2- -d' '`
      ROUTE_DEST=`echo ${ROUTE_NW} | awk '{ print $1 }'`
      ROUTE_IFACE=`echo ${ROUTE_NW} | awk '{ print $4 }'`

      if [ "${ROUTE_OP}" = "ADD" ]; then
        echo "WARNING: Route to dest ${ROUTE_DEST} added for ${ROUTE_IFACE}."
      elif [ "${ROUTE_OP}" = "DEL" ]; then
        echo "WARNING: Route to dest ${ROUTE_DEST} removed for ${ROUTE_IFACE}."
      else
        echo "CRITICAL: Invalid entry found in cache file. Pls check."
      fi
    done
  fi
fi

# Update cache file.
mv ${TMP_FILE} ${CACHE_FILE}
