#!/bin/ksh

# Obtain the variables directly.
ORA_HOME=${ORACLE_HOME}
ORA_SID=${ORACLE_SID}
LIS_NAME=${LISTENER_NAME}

echo "This script is $0\n"
echo "ORACLE_HOME is ${ORA_HOME}."
echo "ORACLE_SID is ${ORA_SID}."
echo "LISTENER_NAME is ${LIS_NAME}."

# You can also obtain them from the env command.
echo "\nThis is from the env command."
env | egrep "ORACLE_HOME|ORACLE_SID|LISTENER_NAME"
