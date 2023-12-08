#!/bin/ksh

SCRIPT_LOCATION=`dirname $0`
SCRIPT_BASE_PATH=`echo ${SCRIPT_LOCATION} | sed 's/\/scripts$//'`
SCRIPT_TMP_PATH=${SCRIPT_BASE_PATH}/tmp
SCRIPT_LOG_PATH=${SCRIPT_BASE_PATH}/log
SCRIPT_CFG_PATH=${SCRIPT_BASE_PATH}/cfg

echo "Script location is ${SCRIPT_LOCATION}"
echo "Tmp location is ${SCRIPT_TMP_PATH}"
echo "Log location is ${SCRIPT_LOG_PATH}"
echo "Cfg location is ${SCRIPT_CFG_PATH}"
