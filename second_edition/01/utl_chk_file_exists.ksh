#!/bin/ksh

INFILE=filelist.txt

chk_file_exists() {
  FILENAME=$1

  if [ -e ${FILENAME} ]; then
    echo "File ${FILENAME} exists."
    return 0
  else
    echo "CRITICAL: File ${FILENAME} does not exist. Pls check."
    return 1
  fi
}

# Main program.
cat ${INFILE} | while read i; do
  chk_file_exists $i
done
