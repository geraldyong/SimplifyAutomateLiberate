#!/bin/ksh

LOGINLOG=/var/adm/loginlog
RPTDAY=$1
PREVDAY=`TZ=GMT+24 date '+%b %d'`
TMPSTATS=/tmp/loginstats_`date '+%Y%m%d'`.tmp
>$TMPSTATS

# Check if any date was passed in.
if [ ! "$RPTDAY" ]; then
  RPTDAY=$PREVDAY
fi

# Obtain list of users from the log. 
# For each user, determine the number of failed logins.
echo "Total No. of Failed User Logins For $RPTDAY"
echo "------------------------------------------\n"
echo "Userid\tFailed Logins"
echo "------\t-------------"
cat $LOGINLOG | egrep "^$RPTDAY" | egrep "auth.notice" | egrep -i "failed" | sed 's/.*for \(.*\) from.*/\1/' | sort | uniq -c | awk '{ print $2 "\t" $1 }'
