#!/bin/ksh

RUNSCRIPT=./sleeper.ksh
OUTFILE=./sleeper.out
>${OUTFILE}

echo "Starting script at `date '+%Y-%m-%d %H:%M:%S'`."

# Run script in the background.
${RUNSCRIPT} > ${OUTFILE} &
SCRIPT_PID=$!

echo "- Created child process PID ${SCRIPT_PID}."
echo "- Waiting for script to complete..."

while true; do
  if [ `ps -ef | grep ${SCRIPT_PID} | grep ${RUNSCRIPT} | grep -v grep | wc -l | tr -d ' '` -eq 0 ]; then
    echo "Script has completed."
    break
  fi
done

echo "Script completed at `date '+%Y-%m-%d %H:%M:%S'`."
