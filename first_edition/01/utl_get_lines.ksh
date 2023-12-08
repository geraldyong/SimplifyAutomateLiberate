#!/bin/ksh

FILENAME=$1
LINESTOTAL=0
LINESREAD=0
LINESTOTAL=`cat ${FILENAME} | wc -l | tr -d ' '`

cat ${FILENAME} | while read i; do
  LINESREAD=$(( LINESREAD+1 ))
  
  if [ `echo "${LINESREAD}%10" | bc` -eq 0 ]; then
    PCTREAD=`echo "${LINESREAD}*100/${LINESTOTAL}" | bc`
    echo "- ${LINESREAD}/${LINESTOTAL} lines read (${PCTREAD}% completed)"
  fi
done

echo "- ${LINESREAD}/${LINESTOTAL} lines read (100% completed)"
