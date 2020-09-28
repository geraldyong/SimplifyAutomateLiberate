#!/bin/ksh

isInteger() {
  typeset TESTNUM
  TESTNUM=$1

  if [ "`echo ${TESTNUM} | sed 's/^-//' | tr -d '[0-9]'`" = "" ]; then
    echo 0
  else
    echo 1
  fi
}

isDigits() {
  typeset TESTNUM
  TESTNUM=$1

  if [ "`echo ${TESTNUM} | tr -d '[0-9]'`" = "" ]; then
    echo 0
  else
    echo 1
  fi
}

isFloat() {
  typeset TESTNUM
  typeset INTPART
  typeset FRACTPART
  TESTNUM=$1

  INTPART=`echo ${TESTNUM} | cut -f1 -d'.'`
  FRACTPART=`echo ${TESTNUM} | cut -f2 -d'.'`

  if [ `isInteger ${INTPART}` -eq 0 ] && [ `isDigits ${FRACTPART}` -eq 0 ]; then
    echo 0
  else
    echo 1
  fi
}

# Main Program.
NUMBER=$1

if [ ! "${NUMBER}" ]; then
  echo "You need to provide a number."
  exit 1
fi

if [ `isInteger ${NUMBER}` -eq 0 ]; then
  echo "Integer"
elif [ `isFloat ${NUMBER}` -eq 0 ]; then
  echo "Float"
else
  echo "Non-float"
fi
