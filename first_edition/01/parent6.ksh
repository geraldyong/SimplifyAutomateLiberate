#!/bin/ksh

echo "\nPls enter the ORACLE_HOME:"
read ORACLE_HOME

echo "\nPls enter the ORACLE_SID:"
read ORACLE_SID

echo "\nPls enter the LISTENER_NAME:"
read LISTENER_NAME

export ORACLE_HOME ORACLE_SID LISTENER_NAME

CHILD_SCRIPT=./child.ksh

# Call the child script.
${CHILD_SCRIPT}
