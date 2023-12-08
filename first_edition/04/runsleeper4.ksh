#!/bin/ksh

RUNSCRIPT=./sleeper.ksh
OUTFILE=./sleeper.out
>${OUTFILE}

spawn_sleeper() {
  typeset SCRIPT_PIDD
  
  ${RUNSCRIPT} >> ${OUTFILE} &
  SCRIPT_PID=$!
  echo "- Created child process PID ${SCRIPT_PID}."
}

# Main Program.

echo "Starting script at `date '+%Y-%m-%d %H:%M:%S'`."

# Run 5 copies of the script in the background.
spawn_sleeper
spawn_sleeper
spawn_sleeper
spawn_sleeper
spawn_sleeper

echo "- Waiting for all scripts to complete..."

while true; do
  if [ `ps -ef | grep ${RUNSCRIPT} | grep -v grep | wc -l | tr -d ' '` -eq 0 ]; then
    echo "All scripts have completed."
    break
  fi
done

echo "Script completed at `date '+%Y-%m-%d %H:%M:%S'`."
