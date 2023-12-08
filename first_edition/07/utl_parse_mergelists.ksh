#!/bin/ksh

cat list2.csv | while read i; do
  COYNAME=`echo $i | cut -f1 -d','`
  COYADDR=`echo $i | cut -f2- -d','`
  COYSALES=`cat list1.csv | egrep "^${COYNAME}," | cut -f2 -d','`
  echo ${COYNAME},${COYADDR},${COYSALES}
done
