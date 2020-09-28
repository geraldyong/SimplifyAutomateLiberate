#!/bin/ksh

FILE1=grades.txt
FILE2=studentid.txt

cat ${FILE1} | while read i; do
  # Extract the name and grade from each line.
  NAME=`echo $i | cut -f1 -d':'`
  GRADE=`echo $i | cut -f2 -d':'`

  # Grep a matching line from the 2nd file, and extract out the studentID from that line.
  STUDENTID=`grep "${NAME}:" ${FILE2} | cut -f2 -d':'`

  # Output the combined information.
  echo "${NAME}:${STUDENTID}:${GRADE}"
done
