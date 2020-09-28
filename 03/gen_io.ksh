#!/bin/ksh

if [ $# -lt 1 ]; then
  echo "Usage: $0 { location } [ mkfile filesize ]"
  exit 0
fi

OS_TYPE=`uname -s`
LOCATION=$1
FILESIZE=$2
FILENAME=genio_`date '+%d%b%Y'`.tmp
ITER=0

# Function for exiting with error message.
err_exit() {
  typset MSG
  MSG=$1
  echo "$MSG"
  exit 1
}

# Set up break trap.
housekeep() {
  echo "\nBreak detected. Deleting ${LOCATION}/${FILENAME}"
  rm -f ${LOCATION}/${FILENAME}
  echo "Done."
  exit 0
}

# OS specific adjustments.
if [ "${OS_TYPE}" = "Linux" ]; then
  MKFILE=`which dd`
  DEFAULT_FILESIZE=1024k
  test ! "${FILESIZE}" && FILESIZE=${DEFAULT_FILESIZE}
  MKCMD="${MKFILE} if=/dev/zero of=${FILENAME} bs=1024 count=${FILESIZE}"
elif [ "${OS_TYPE}" = "SunOS" ]; then
  MKFILE=`which mkfile`
  DEFAULT_FILESIZE=100m
  test ! "${FILESIZE}" && FILESIZE=${DEFAULT_FILESIZE}
  MKCMD="${MKFILE} ${FILESIZE} ${FILENAME}"
else
  err_exit "CRITICAL: OS ${OS_TYPE} is not supported. Pls chk."
fi
test ! "${MKFILE}" && err_exit "CRITICAL: Unable to find bin ${MKFILE}. Pls chk your PATH."
test ! -e ${LOCATION} && err_exit "CRITICAL: Path ${LOCATION} does not exist. Pls chk."

# Perform a test.
cd ${LOCATION}
touch ${LOCATION}/${FILENAME}
test $? -gt 0 && err_exit "CRITICAL: Cannot create ${FILENAME} on ${LOCATION}. Pls chk."

# Run the iterations.
trap housekeep INT

# Repeatedly create and remove temporary file to generate IO, until
# the BREAK key is pressed.
while true; do
  clear
  ITER=$(( ITER+1 ))
  echo "Current iteration: $ITER"
  echo "(Press CTRL-C or BREAK to stop.)\n"
  echo "- Creating temp file ${LOCATION}/${FILENAME} size $FILESIZE"
  echo "$MKCMD" | sh
  echo "- Removing temp file ${LOCATION}/${FILENAME}..."
  rm -f ${LOCATION}/${FILENAME}

  if [ -e "${LOCATION}/${FILENAME}" ]; then
    echo "WARNING: Unable to remove file ${LOCATION}/${FILENAME}. Pls chk."
    sleep 5
  fi
done
