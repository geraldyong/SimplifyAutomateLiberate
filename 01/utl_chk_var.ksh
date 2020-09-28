#!/bin/ksh

VAR=$1

if [ ! "${VAR}" ]; then
  echo "Variable is empty."
elif [ "`echo "${VAR}" | tr -d '[0-9]'`" = "" ]; then
  echo "Variable ${VAR} contains only digits."
elif [ "`echo "${VAR}" | tr -d '[A-z]'`" = "" ]; then
  echo "Variable ${VAR} contains only letters."
elif [ "`echo "${VAR}" | tr -d '[0-9]' | tr -d '[A-z]'`" = "" ]; then
  echo "Variable ${VAR} contains only letters and digits."
else
  echo "Variable ${VAR} is not alphanumeric."
fi
