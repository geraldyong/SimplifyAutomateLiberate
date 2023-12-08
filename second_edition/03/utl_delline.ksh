#!/bin/ksh

SEARCHSTR="Department"

ls -1 | while read i; do
  sed "/${SEARCHSTR}/d" $i > $i.tmp
  mv $i.tmp $i
done
