#!/bin/ksh

CONFIG_FILE=./ora3.cfg

# Obtain instance from arguments.
INSTANCE=$1

# Obtain the config for the specified instance from the config file.
egrep "^${INSTANCE}:" ${CONFIG_FILE} | while read i; do
  ORACLE_HOME=`echo $i | awk -F: '{ print $1 }'`
  ORACLE_SID=`echo $i | awk -F: '{ print $2 }'`
  LISTENER_NAME=`echo $i | awk -F: '{ print $3 }'`
done

# Export the variables so that the calling script can see them.
export ORACLE_HOME ORACLE_SID LISTENER_NAME

CHILD_SCRIPT=./child.ksh

# Call the child script.
${CHILD_SCRIPT}
