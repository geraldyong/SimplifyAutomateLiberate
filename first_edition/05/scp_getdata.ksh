#!/bin/ksh

SCP=`which scp`
SCPUSER=geraldy
SCPTARGET=solaris1
SCPFILE=data.txt

get_data() {
  # Copies the file from the remote server.

  $SCP -p ${SCPUSER}@${SCPTARGET}:~/${SCPFILE} /tmp

  if [ $? -gt 0 ]; then
    echo "CRITICAL: Errors occurred while performing SCP. Pls check."
    exit 1
  fi
}

# Main program.
get_data
