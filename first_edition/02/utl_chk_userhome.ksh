#!/bin/ksh

HOME_ROOT=/export/home
HOME_ROOT_SIZE=`df -k ${HOME_ROOT} | awk '{ print $2 }' | tail -1`
HOME_ROOT_SIZE2=`echo ${HOME_ROOT_SIZE} | sed -e :a -e 's/\(.*[0-9]\)\([0-9][0-9][0-9]\)/\1,\2/;ta'`

# Print out total available space.
cd ${HOME_ROOT}
echo "Available space on ${HOME_ROOT}:\n${HOME_ROOT_SIZE2}kb\n"

# Loop through each user and list out the user's home usage.
du -sk * | grep -v "lost+found" | sort -nr | while read i; do
  USER_KB_USED=`echo $i | awk '{ print $1 }'`
  USER_KB_USED2=`echo ${USER_KB_USED} | sed -e :a -e 's/\(.*[0-9]\)\([0-9][0-9][0-9]\)/\1,\2/;ta'`
  USER_NAME=`echo $i | awk '{ print $2 }'`
  USER_PCT=`echo "${USER_KB_USED}*100/${HOME_ROOT_SIZE}" | bc`
 
  printf %-15s "${USER_NAME}"
  printf %12s "${USER_KB_USED2}kb"
  printf %7s  "(${USER_PCT}%)"
  echo
done 
