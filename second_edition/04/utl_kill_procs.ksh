#!/bin/ksh

USERID=$1

if [ ! "${USERID}" ]; then
  echo "CRITICAL: No userid specified. Pls check."
  exit 1
fi

kill_user() {
  typeset UPROCS
  
  UPROCS=`ps -u ${USERID} | awk '{ print $1 }' | egrep -v "PID" | xargs`

  echo "These processes belong to userid ${USERID}:\n"
  ps -fu ${USERID}

  echo "\nPress ENTER to continue."
  read TMP

  echo "\nDo you wish to kill the above processes? (YES to confirm)"
  read TMP

  if [ "${TMP}" = "YES" ]; then
    echo "\nKilling processes belonging to userid ${USERID}..."
    echo "kill -9 ${UPROCS}"
    echo "Done."
  else
    echo "Aborted."
  fi
}

# Main program.
kill_user
