#!/bin/ksh

INFILE=employee.dat
SEARCHFIELD="Department"
SEARCHVALUE="Marketing"
DEL_REC=YES

print_rec() {
  if [ ! "${DEL_REC}" = "YES" ]; then
    echo "Name=${NAME}"
    echo "Address=${ADDRESS}"
    echo "Age=${AGE}"
    echo "Department=${DEPT}"
  fi

  NAME=""
  ADDRESS=""
  AGE=""
  DEPT=""
  DEL_REC=NO
}

cat $INFILE | while read i; do
  FIELD=`echo $i | cut -f1 -d'='`
  VALUE=`echo $i | cut -f2- -d'='`

  case ${FIELD} in
    "Name")        print_rec; NAME=${VALUE};;
    "Address")     ADDRESS=${VALUE};;
    "Age")         AGE=${VALUE};;
    "Department")  DEPT=${VALUE};;
  esac

  if [ "${FIELD}" = "${SEARCHFIELD}" ] &&
    [ `echo ${VALUE} | egrep "${SEARCHVALUE}" | wc -l | tr -d ' '` -gt 0 ]; then
      DEL_REC=YES
  fi
done

# Print out final record.
print_rec
