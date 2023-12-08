#!/bin/ksh

SULOG=/var/adm/sulog
RPTDAY=$1
PREVDAY=`TZ=GMT+24 date '+%m/%d'`

# Check if any date was passed in.
if [ ! "$RPTDAY" ]; then
  RPTDAY=$PREVDAY
fi

# Obtain list of users from the log. 
# For each user, determine the number of logins.
echo "Top User su Logins for $RPTDAY"
echo "============================\n"
echo "Username\tsu logins"
echo "--------\t---------"

cat $SULOG | egrep "^SU $RPTDAY" | egrep -v "root-" | egrep "\-root" | awk '{ print $6 }' | sort | uniq -c | awk '{ print $2 "\t" $1 }'
