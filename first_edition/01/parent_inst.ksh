#!/bin/ksh

SCRIPT_NAME=`basename $0`
ORACLE_SID=`echo ${SCRIPT_NAME} | sed 's/\..*//' | cut -f2 -d'_'`

CONFIG_FILE=./ora3.cfg

CONFIG_LINE=`egrep "^${ORACLE_SID}" ${CONFIG_FILE}`

ORACLE_HOME=`echo ${CONFIG_LINE} | awk -F: '{ print $2 }'`
LISTENER_NAME=`echo ${CONFIG_LINE} | awk -F: '{ print $3 }'`

export ORACLE_HOME ORACLE_SID LISTENER_NAME

CHILD_SCRIPT=./child.ksh

# Call the child script.
${CHILD_SCRIPT}
