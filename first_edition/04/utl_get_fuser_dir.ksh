#!/bin/ksh

FUSER=`which fuser`
FDIR=$1

if [ ! "${FDIR}" ]; then
  FDIR='.'
elif [ ! -e ${FDIR} ]; then
  echo "CRITICAL: Directory ${FDIR} does not exist. Pls check."
  exit 1
fi

chk_user_root() {
  USERID=`id | cut -f2 -d'(' | cut -f1 -d')'`

  if [ ! "${USERID}" = "root" ]; then
    echo "CRITICAL: You must be root to run this script."
    exit 1
  fi
}

fuser_dir() {
  cd ${FDIR}
  ls -1 | while read i; do
    FPROCS=`${FUSER} $i 2>/dev/null | xargs` 

    if [ "${FPROCS}" ]; then
      echo "$i: ${FPROCS}"
    fi
  done
}

# Main 
chk_user_root
fuser_dir
