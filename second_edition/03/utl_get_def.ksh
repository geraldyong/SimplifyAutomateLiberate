#!/bin/ksh

SCRIPT_NAME=`basename $0`
THISOS=`uname -s`

# Obtain the settings for this OS.
DEFAULTS=`cat ${SCRIPT_NAME} | grep "^#DATA:" | grep "${THISOS}:"`

if [ ! "${DEFAULTS}" ]; then
  echo "CRITICAL: Can't find defaults for your OS ${THISOS}."
  exit 1
fi

# Extract the settings.
A=`echo ${DEFAULTS} | cut -f3 -d':'`
B=`echo ${DEFAULTS} | cut -f4 -d':'`
C=`echo ${DEFAULTS} | cut -f5 -d':'`

echo "OS is ${THISOS}. A is $A. B is $B. C is $C."


# -------------------------------------------------------------
# Data Portion
# -------------------------------------------------------------
#DATA:SunOS:10:20:10
#DATA:Linux:20:30:20
#DATA:HP-UX:30:10:30
