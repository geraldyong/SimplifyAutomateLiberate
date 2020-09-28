#!/bin/ksh

RUNSCRIPT=./sleeper.ksh
OUTFILE=./sleeper.out
>${OUTFILE}

echo "Starting script at `date '+%Y-%m-%d %H:%M:%S'`."

# Run script in the background.
${RUNSCRIPT} > ${OUTFILE} &

echo "- Created child process PID $!."
echo "- Waiting for script to complete..."

while true; do
  if [ `tail ${OUTFILE} | grep ^Completed | wc -l | tr -d ' '` -gt 0 ]; then
    echo "Script has completed."
    break
  fi
done

echo "Script completed at `date '+%Y-%m-%d %H:%M:%S'`."
