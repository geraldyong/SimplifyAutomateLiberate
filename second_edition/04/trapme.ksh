#!/bin/ksh

function trapme {
  typeset TRAPCODE
  TRAPCODE=$1

  if [ "$TRAPCODE" = "INT" ]; then
    echo "CRITICAL: CTRL-BREAK pressed. Exiting."
    exit 0
  else
    echo "CRITICAL: Received trap $TRAPCODE."
  fi
}

trap "trapme HUP" HUP
trap "trapme INT" INT

PID=$$

echo "PID for this process is $PID."
echo "You can try kill -HUP $PID."
echo "You can also try CTRL+BREAK."
echo "You can issue kill -9 $PID to kill this process."

while true; do
  sleep 10
done
