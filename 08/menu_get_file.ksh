#!/bin/ksh

# Display the menu.
show_menu() {
  typeset MENUCHOICE
  typeset FILE
  MENUCHOICE=1

  # Display menu.
  clear
  echo "View File Menu"
  echo "--------------"
  echo

  # Generate a choice for each file.
  ls -1 | while read FILE; do
    echo "${MENUCHOICE}. ${FILE}"
    MENUCHOICE=$(( MENUCHOICE+1 ))
  done

  echo
  echo "x. Exit"
  echo
  echo "Choice:"
}

# Obtains a menu choice.
get_option() {
  typeset FILE
  typeset CHOICE
  typeset NUMCHOICES

  NUMCHOICES=`ls -1 | wc -l | tr -d ' '`

  while true; do
    show_menu
    read CHOICE

    if [ "${CHOICE}" = "x" ]; then
      break;
    elif [ ${CHOICE} -gt ${NUMCHOICES} ]; then
      echo "CRITICAL: Selected choice is not in the list. Pls check."
    else
      FILE=`ls -1 | head -n${CHOICE} | tail -1`

      if [ ! "${FILE}" ]; then
        echo "CRITICAL: Invalid choice."
      elif [ ! -e ${FILE} ]; then
        echo "CRITICAL: Selected file ${FILE} does not exist."
      else
        echo
        echo "You have selected file ${FILE}. Press ENTER to view the file."
        read TMP
        echo "-------------------------------------------"
        cat ${FILE}
        echo "-------------------------------------------"
      fi
    fi

    echo
    echo "Press ENTER to return to menu."
    read TMP
  done
}

# Main program.
get_option
