#!/bin/ksh

HOSTNAME=`hostname`
USERID=`id | cut -f2 -d'(' | cut -f1 -d')'`
TITLE="Hello ${USERID}. Welcome to ${HOSTNAME}."

gen_title() {
  typeset TITLESTR
  TITLESTR=$1

  echo ${TITLESTR} | sed 's/./-/g'
}

echo ${TITLE}
gen_title "${TITLE}"
