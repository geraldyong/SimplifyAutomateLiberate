#!/bin/ksh

CONFIG_FILE=config2.cfg

egrep -v "^$|^#" ${CONFIG_FILE} | while read i; do
  FIELD=`echo $i | cut -f1 -d'='`
  VALUE=`echo $i | cut -f2- -d'='`

  if [ "${FIELD}" = "field1" ]; then
    OPTION1=${VALUE}
  elif [ "${FIELD}" = "field2" ]; then
    OPTION2=${VALUE}
  elif [ "${FIELD}" = "field3" ]; then
    OPTION3=${VALUE}
  fi
done

echo "OPTION1 ${OPTION1}"
echo "OPTION2 ${OPTION2}"
echo "OPTION3 ${OPTION3}"
