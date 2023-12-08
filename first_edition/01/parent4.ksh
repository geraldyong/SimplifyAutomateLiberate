#!/bin/ksh

if [ $# -lt 3 ]; then
  echo "CRITICAL: You need to pass in 3 arguments to this script"
  echo "          in the following order:"
  echo "          ./parent4.ksh {ORACLE_HOME} {ORACLE_SID} {LISTENER_NAME}"
  exit 1
fi

ORACLE_HOME=$1
ORACLE_SID=$2
LISTENER_NAME=$3
export ORACLE_HOME ORACLE_SID LISTENER_NAME

CHILD_SCRIPT=./child.ksh

# Call the child script.
${CHILD_SCRIPT}
