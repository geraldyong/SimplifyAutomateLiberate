#!/bin/ksh

FUSER=`which fuser`
FDIR=$1

if [ ! "${FDIR}" ]; then
  FDIR='.'
elif [ ! -e ${FDIR} ]; then
  echo "CRITICAL: Directory ${FDIR} does not exist. Pls check."
  exit 1
fi
if [ `df -k | awk '{ print $NF }' | egrep "^${FDIR}$" | wc -l | tr -d ' '` -eq 0 ]; then
  echo "CRITICAL: Directory ${FDIR} is not a mount point. Pls check."
  exit 1
fi

chk_user_root() {
  USERID=`id | cut -f2 -d'(' | cut -f1 -d')'`

  if [ ! "${USERID}" = "root" ]; then
    echo "CRITICAL: You must be root to run this script."
    exit 1
  fi
}

fuser_mtpt() {
  cd ${FDIR}
  FPROCS=`${FUSER} -c ${FDIR} 2>/dev/null | xargs`

  echo "These are the process IDs which are using the mount point ${FDIR}:"
  echo ${FPROCS}
  echo "\nPress ENTER to continue." 
  read TMP

  echo "These are the corresponding processes."
  ps -fp "${FPROCS}"
  echo "\nPress ENTER to continue." 
  read TMP

  echo "Do you wish to kill all the above processes? (YES to confirm)"
  read TMP
  if [ "${TMP}" = "YES" ]; then
    echo "\nKilling processes..."
    kill -9 ${FPROCS}
    echo "Done."
  else
    echo "Aborted."
  fi
}

# Main 
chk_user_root
fuser_mtpt
