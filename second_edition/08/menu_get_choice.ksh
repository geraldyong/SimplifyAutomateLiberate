#!/bin/ksh
 
# Print out the menu.
show_menu() {
  clear
  echo "Menu"
  echo "----"
  echo
  echo "1. Option 1"
  echo "2. Option 2"
  echo "3. Option 3"
  echo "4. Option 4"
  echo "A. Option A"
  echo
  echo "x. Exit"
  echo
  echo "Choice: "
}
 
# Obtains a menu option.
get_option() {
  while true; do
    show_menu
    read CHOICE
     
    case $CHOICE in
      1) echo "Option 1 selected!";;
      2) echo "Option 2 selected!";;
      3) echo "Option 3 selected!";;
      4) echo "Option 4 selected!";;
      A) echo "Option A selected!";;
      x) break;;
      *) echo "CRITICAL: Menu option is not recognised.";;
    esac
 
    echo "Press ENTER to return to menu."
    read TMP
  done
}
 
# Main program.
get_option
