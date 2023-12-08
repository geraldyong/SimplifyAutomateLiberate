#!/bin/ksh

OPTION_FILE=menu_sysadmin.cfg

# Display the menu.
show_menu() {
  typeset PID
  typeset PROC
  typeset CHOICE_NAME
  typeset CHOICE_OPT 
  CHOICE_OPT=0

  # Display menu.
  clear
  echo "SysAdmin Menu"
  echo "-------------"
  echo

  # Generate a choice for each process.  
  cat ${OPTION_FILE} | while read i; do
    CHOICE_NAME=`echo $i | cut -f1 -d':'`
    CHOICE_OPT=$(( CHOICE_OPT+1 ))
    echo "${CHOICE_OPT}. ${CHOICE_NAME}"
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
  typeset CHOICE_LINE
  typeset CHOICE_NAME
  typeset CHOICE_PROG
  typeset NUMCHOICES
  NUMCHOICES=`cat ${OPTION_FILE} | wc -l | tr -d ' '`

  while true; do
    show_menu
    read CHOICE

    if [ "${CHOICE}" = "x" ]; then  
      break; 
    elif [ ! "${CHOICE}" ] || [ ${CHOICE} -gt ${NUMCHOICES} ] || [ ${CHOICE} -eq 0 ]; then
      echo "CRITICAL: Selected choice $CHOICE is not in the list. Pls check."
    else
      CHOICE_LINE=`cat ${OPTION_FILE} | head -$CHOICE | tail -1`
      CHOICE_NAME=`echo ${CHOICE_LINE} | cut -f1 -d':'`
      CHOICE_PROG=`echo ${CHOICE_LINE} | cut -f2 -d':'`
   
      echo "You selected ${CHOICE_NAME}. Press ENTER to run ${CHOICE_PROG}."
      read TMP
      `${CHOICE_PROG}`
    fi

    echo
    echo "Press ENTER to return to menu."
    read TMP
  done
}

# Main program.
get_option
