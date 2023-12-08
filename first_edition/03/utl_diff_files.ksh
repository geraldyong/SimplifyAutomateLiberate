#!/bin/ksh

DIR1=/export/home/geraldy/scripts/03/dir1
DIR2=/export/home/geraldy/scripts/03/dir2
CKSUM_FILE=cksum.txt

gen_checksum() {
  typeset TARGETDIR
  TARGETDIR=$1
  
  cd ${TARGETDIR}
  cksum * > ${CKSUM_FILE}
}

gen_checksum ${DIR1}
gen_checksum ${DIR2}

diff ${DIR1}/${CKSUM_FILE} ${DIR2}/${CKSUM_FILE}
