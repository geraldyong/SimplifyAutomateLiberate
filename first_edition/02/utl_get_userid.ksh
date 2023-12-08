#!/bin/ksh

USERID=`id | cut -f2 -d'(' | cut -f1 -d')'`

echo "Your userid is ${USERID}."
