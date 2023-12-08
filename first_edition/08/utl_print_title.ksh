#!/bin/ksh

HOSTNAME=`hostname`
USERID=`id | cut -f2 -d'(' | cut -f1 -d')'`
TITLE="Hello ${USERID}. Welcome to ${HOSTNAME}."

echo ${TITLE}
echo ${TITLE} | sed 's/./-/g'
