#!/bin/ksh

WARN_THRES=75
CRIT_THRES=90
CFGFILE=mon_disk_full.cfg

chk_disk_full() {
  # Reformats and reads df -k output.
  df -k | tail +2 | awk '{ print $5,$2,$3,$4,$1,$6 }' | tr -d '%' | sort -r | while read i; do
    PCT_USED=`echo $i | cut -f1 -d' '`
    PARTITION=`echo $i | cut -f6 -d' '`
    KB_FREE=`echo $i | cut -f4 -d' '`

    if [ `grep "^EXCLUDE ${PARTITION}$" ${CFGFILE} | wc -l | tr -d ' '` -eq 0 ]; then
      if [ ${PCT_USED} -ge ${WARN_THRES} ] && [ ${PCT_USED} -lt ${CRIT_THRES} ]; then
        echo "WARNING: Parition ${PARTITION} has ${KB_FREE}kb avail and is ${PCT_USED}% full!"
      elif [ ${PCT_USED} -ge ${CRIT_THRES} ]; then
        echo "CRITICAL: Parition ${PARTITION} has ${KB_FREE}kb avail and is ${PCT_USED}% full!"
      fi
    fi
  done
}


# Main program.
chk_disk_full
