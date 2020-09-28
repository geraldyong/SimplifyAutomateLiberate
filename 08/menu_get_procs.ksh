#!/bin/ksh

# Display the menu.
show_menu() {
  typeset PID
  typeset PROC

  # Display menu.
  clear
  echo "View Process Menu"
  echo "------------------"
  echo

  # Generate a choice for each process.
  ps -ef | grep "bash" | grep -v grep | while read i; do
    PID=`echo $i | awk '{ print $2; }'`
    PROC=`echo $i | cut -f8- -d' '`
    echo "${PID}. ${PROC}"
  done

  echo
  echo "x. Exit"
  echo
  echo "Choice:"
}

# Obtains a menu choice.
get_option() {
  typeset PROC
  typeset CHOICE
  typeset NUMCHOICES

  while true; do
    show_menu
    read CHOICE

    if [ "${CHOICE}" = "x" ]; then
      break;
    elif [ `ps -ef | grep "bash" | grep -v grep | awk '{ print $2; }' | grep "^${CHOICE}$" | wc -l | tr -d ' '` -gt 0 ]; then
      echo "You have selected PID ${CHOICE}."
    else
      echo "CRITICAL: Selected choice ${CHOICE} is not in the list. Pls check."
    fi

    echo
    echo "Press ENTER to return to menu."
    read TMP
  done
}

# Main program.
get_option
