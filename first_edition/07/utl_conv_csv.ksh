#!/bin/ksh

cat employee.dat | while read i; do
  FIELD=`echo $i | cut -f1 -d'='`
  VALUE=`echo $i | cut -f2- -d'='`

  case ${FIELD} in 
    "Name")       NAME=${VALUE};;
    "Address")    ADDRESS=${VALUE};;
    "Age")        AGE=${VALUE};;
    "Department") 
      DEPT=${VALUE}
      echo "${NAME},${ADDRESS},${AGE},${DEPT}"
      NAME=""
      ADDRESS=""
      AGE=""
      DEPT=""
      ;;
  esac
done
