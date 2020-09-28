#!/bin/ksh

# Global variables.
IMPL_FOLDER=/export/home/geraldy/impl/2010
IMPL_FILE=""

get_impl_file() {
  typeset FILE_LOC
  typeset FILE_NUM
  typeset NUM_FILES
  FILE_LOC=$1

  # Here we assume the location has already been checked as valid and it exists.
  
  NUM_FILES=`file ${FILE_LOC}/* | grep "text" | wc -l | tr -d ' '`
  
  if [ ${NUM_FILES} -eq 0 ]; then
    echo "CRITICAL: No valid files found in ${FILE_LOC}. Pls check."
    return 1
  fi

  while true; do
    FILE_NUM=0
    echo "\nThe following files are found in ${FILE_LOC}:"

    cd ${FILE_LOC}
    file * | grep "text" | sort | cut -f1 -d':' | while read i; do
      FILE_NUM=$(( FILE_NUM + 1 ))
      echo "${FILE_NUM}. $i"
    done

    NUM_FILES=${FILE_NUM}

    echo "\nPlease select the file to run:"  
    read IMPL_FILE
    
    if [ ! "${IMPL_FILE}" ]; then 
      echo "CRITICAL: No file entered. Pls try again."
    elif [ "${IMPL_FILE}" = "x" ]; then
      break
    elif [ "`echo "${IMPL_FILE}" | tr -d '[0-9]'`" = "" ]; then
      # A number was entered.
      # Determine the file name.
      if [ ${IMPL_FILE} -gt ${NUM_FILES} ] || [ ${IMPL_FILE} -eq 0 ]; then
        echo "CRITICAL: The number entered was not in the list. Pls try again."
      else
        FILE=`file * | grep "text" | sort | cut -f1 -d':' | head -n${IMPL_FILE} | tail -1`
        IMPL_FILE=${FILE}
        break
      fi
    else
      # A value which is not a number was entered.
      # Assume it's the file name, so check if it exists.
      if [ ! -e "${IMPL_FILE}" ]; then
        echo "CRITICAL: File ${IMPL_FILE} does not exist. Pls try again."
      else
        break
      fi
    fi
  done

  if [ "${IMPL_FILE}" = "x" ]; then
    echo "Aborted."
  else
    echo "\nYou have selected the following:"
    echo "\nFile:\t${IMPL_FILE}\n"
  fi
}


# Main program.
get_impl_file ${IMPL_FOLDER}
