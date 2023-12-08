#!/bin/ksh

LOGDATE=`date '+%Y%m%d'`
LOGPATH=.
COMPRESS_DAYS=2
REMOVE_DAYS=5

cd ${LOGPATH}

# Create the log for the day.
for i in system.log application.log error.log; do
  echo "Creating $i.${LOGDATE}..."
  cat $i >> $i.${LOGDATE}
  >$i

  # Housekeep logs.
  find ./$i.* -mtime +${COMPRESS_DAYS} -exec compress {} \;
  find ./$i.*.Z -mtime +${REMOVE_DAYS} -exec rm -f {} \;
done
