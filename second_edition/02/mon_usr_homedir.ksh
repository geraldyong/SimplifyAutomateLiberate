#!/bin/ksh

WARN_THRES=40000
CRIT_THRES=80000
HOME_PATH=/export/home

cd ${HOME_PATH}
du -sk * | grep -v "lost+found" | sort -nr | while read i; do
  DIR_SIZE=`echo $i | awk '{ print $1 }'`
  DIR_NAME=`echo $i | awk '{ print $2 }'`

  if [ ${DIR_SIZE} -lt ${WARN_THRES} ]; then
    break
  elif [ ${DIR_SIZE} -ge ${WARN_THRES} ] && [ ${DIR_SIZE} -lt ${CRIT_THRES} ]; then
    echo "WARNING: Home dir ${HOME_PATH}/${DIR_NAME} is ${DIR_SIZE}kb, exceeds warn thres ${WARN_THRES}kb."
  else
    echo "CRITICAL: Home dir ${HOME_PATH}/${DIR_NAME} is ${DIR_SIZE}kb, exceeds crit thres ${CRIT_THRES}kb."
  fi
done
