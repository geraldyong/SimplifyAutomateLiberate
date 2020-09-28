#!/bin/ksh

echo "Pls enter a value:"
read VAR

if [ "`echo "${VAR}" | sed 's/^-//' | tr -d '[0-9]'`" = "" ]; then
  echo "Variable ${VAR} is an integer."
else
  echo "Variable ${VAR} is not an integer."
fi
