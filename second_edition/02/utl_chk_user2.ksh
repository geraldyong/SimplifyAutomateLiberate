#!/bin/ksh

chk_user() {
  typeset CHKUSRS
  CHKUSRS=$1
  USERID=`id | cut -f2 -d'(' | cut -f1 -d')'`

  echo "${CHKUSRS}" | tr -s ',' '\n' | while read i; do
    if [ "${USERID}" = "$i" ]; then
      return 0
    fi
  done

  echo "CRITICAL: Your userid ${USERID} is not allowed to run this script."
  exit 1
}

# Main program.

chk_user root,kelvinq
echo "This user can run this script."
