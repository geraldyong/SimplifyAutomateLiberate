#!/bin/ksh

function trapbreak {
  typeset TRAPCODE
  TRAPCODE=$1

  if [ "$TRAPCODE" = "INT" ]; then
    echo "CRITICAL: CTRL-BREAK pressed. Exiting."
    stty echo
    exit 0
  fi
}

trap "trapbreak INT" INT


echo "\nPassword hidden"
echo "---------------"
echo "Pls enter your password:"
stty -echo
read PASSWD2
stty echo
echo "You entered $PASSWD2."
