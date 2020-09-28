#!/bin/ksh

IMPL_FOLDER=/export/home/geraldy/impl/2010
USERNAME_DEFAULT="admin"

get_impl_user() {
  typeset USERNAME
  typeset USERPWD
  USERNAME=${USERNAME_DEFAULT}
  USERPWD=""

  echo "\nPlease enter the user to run the script:"
  echo "(default: ${USERNAME_DEFAULT})"
  read USERNAME

  if [ ! "${USERNAME}" ]; then
    USERNAME=${USERNAME_DEFAULT}
  else
    USERNAME_DEFAULT=${USERNAME}
  fi

  echo "\nPlease enter the password for ${USERNAME}:"
  stty -echo
  read USERPWD
  stty echo

  echo "\nYou have chosen to run the following:\n"
  echo "Script: ${IMPL_FILE}"
  echo "User:   ${USERNAME}"

  echo "\nPlease press YES to proceed, or any other key to abort."
  read TMP

  if [ "$TMP" = "YES" ]; then
    return 0
  else
    echo "Aborted."
    return 1
  fi
}

# Main Program.

# Obtains the user the first time.
IMPL_FILE=impl_tsi_20100720.sql
get_impl_user

if [ $? -eq 0 ]; then
  echo "\nRunning script..."
  # Code to run report comes in here.
  echo "\nDone."
fi

# Obtains the user the second time.
IMPL_FILE=impl_tsi_20100720.sql
get_impl_user

if [ $? -eq 0 ]; then
  # Code to run report comes in here.
  echo "Done."
fi
