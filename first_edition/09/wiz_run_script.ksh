#!/bin/ksh

IMPL_FOLDER=/export/home/geraldy/impl/2010
IMPL_FILE=impl_tsi_20100720.sql
USERNAME=tsiuser

run_report() {
  typeset PROGRAM
  typeset OUTFILE
  PROGRAM=/export/home/geraldy/scripts/gen_report.ksh
  OUTFILE=/tmp/gen_report_`date '+%Y%m%d%H%M%S'`.log

  echo "\nRunning report...\n"
  echo "${PROGRAM} ${IMPL_FOLDER}/${IMPL_FILE} ${USERNAME}" | sh >${OUTFILE} 2>&1

  if [ $? -eq 0 ]; then
    echo "\nThe report was generated successfully."
    echo "Output file is saved in ${OUTFILE}"
  else
    NUM_ERRS=`cat ${OUTFILE} | egrep "^CRITICAL" | wc -l | tr -d ' '`

    echo "\nCRITICAL: ${NUM_ERRS} errors detected during report run.\n"
    echo "Press ENTER to view the errors."
    read TMP
 
    echo "List of errors:"
    echo "------------------------------------"
    cat ${OUTFILE} | egrep "^CRITICAL"
    echo "------------------------------------"
  fi
} 


# Main Program.

echo "\nYou have chosen to run the following:\n"
echo "File:  ${IMPL_FILE}"
echo "User:  ${USERNAME}"
echo "\nPress YES to proceed or any other key to abort."
read TMP

if [ "$TMP" = "YES" ]; then
  run_report ${IMPL_FOLDER} ${IMPL_FILE} ${USERNAME}
else
  echo "Aborted."
fi
