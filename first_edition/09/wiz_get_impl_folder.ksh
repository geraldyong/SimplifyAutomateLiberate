#!/bin/ksh

# Global variables.
IMPL_FOLDER_DEFAULT=/export/home/geraldy/impl/2010
IMPL_FOLDER=""


get_impl_folder() {
  echo "Please enter the location of the implementation folder:"
  echo "(Default: ${IMPL_FOLDER_DEFAULT})"

  while [ "${IMPL_FOLDER}" != "x" ]; do 
    read IMPL_FOLDER

    # If nothing was entered, take the default value.
    if [ ! "${IMPL_FOLDER}" ]; then
      IMPL_FOLDER=${IMPL_FOLDER_DEFAULT}
    fi

    # Check if the folder exists.
    if [ ! -e "${IMPL_FOLDER}" ]; then 
      # If it does not exist, prompt the user to enter again.
      echo "CRITICAL: The folder ${IMPL_FOLDER} does not exist.\n"
      echo "Please enter the location of the implementation folder again, or press 'x' to abort."
    elif [ `ls -l ${IMPL_FOLDER} | egrep -v "^total" | wc -l | tr -d ' '` -eq 0 ]; then
      # Check if any files exist in the folder.
      echo "CRITICAL: No files found in ${IMPL_FOLDER}\n"
      echo "Please enter another location for the implementation folder, or press 'x' to abort."
    else
      # Update the default, so that the next time this function is called,
      # it will "remember" the previously entered value.
      IMPL_FOLDER_DEFAULT=${IMPL_FOLDER}
      break;
    fi
  done

  if [ "${IMPL_FOLDER}" = "x" ]; then
    echo "Aborted."
  else
    echo "\nImpl Folder: ${IMPL_FOLDER}"
  fi
}


# Main program.
get_impl_folder
