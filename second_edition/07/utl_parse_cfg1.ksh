#!/bin/ksh

CONFIG_FILE=config1.cfg
REQ_OPT="CONFIG2"

CONFIG_LINE=`egrep -v "^$|^#" ${CONFIG_FILE} | egrep "^${REQ_OPT}`
PARAM1=`echo ${CONFIG_LINE} | cut -f2 -d':'`
PARAM2=`echo ${CONFIG_LINE} | cut -f3 -d':'`
PARAM3=`echo ${CONFIG_LINE} | cut -f4 -d':'`

echo "PARAM1: ${PARAM1}"
echo "PARAM2: ${PARAM2}"
echo "PARAM3: ${PARAM3}"
