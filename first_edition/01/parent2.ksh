#!/bin/ksh

CONFIG_FILE=./ora.cfg
. ${CONFIG_FILE}

CHILD_SCRIPT=./child.ksh

# Call the child script.
${CHILD_SCRIPT}
