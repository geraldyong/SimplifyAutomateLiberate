#!/bin/ksh

chk_user() {
  typeset CHKUSR
  CHKUSR=$1
  USERID=`id | cut -f2 -d'(' | cut -f1 -d')'`

  if [ ! "${USERID}" = "${CHKUSR}" ]; then
    echo "CRITICAL: You must be ${CHKUSR} to run this script."
    exit 1
  fi
}

# Main Program.

chk_user root 
echo "root can run this script."
