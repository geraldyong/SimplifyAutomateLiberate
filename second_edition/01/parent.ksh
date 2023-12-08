#!/bin/ksh

ORACLE_HOME=/opt/oracle/product/10.2
ORACLE_SID=MYDBP
LISTENER_NAME=LISTENER_MYDBP
export ORACLE_HOME ORACLE_SID LISTENER_NAME

CHILD_SCRIPT=./child.ksh

# Call the child script.
${CHILD_SCRIPT}
