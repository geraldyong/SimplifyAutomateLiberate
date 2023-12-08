#!/bin/ksh

CONFIG_FILE=./ora2.cfg

egrep -v "^#|^$" ${CONFIG_FILE} | while read i; do
  ORACLE_HOME=`echo $i | awk -F: '{ print $1 }'`
  ORACLE_SID=`echo $i | awk -F: '{ print $2 }'`
  LISTENER_NAME=`echo $i | awk -F: '{ print $3 }'`
done

export ORACLE_HOME ORACLE_SID LISTENER_NAME

CHILD_SCRIPT=./child.ksh

# Call the child script.
${CHILD_SCRIPT}
