#!/bin/ksh

TGTUSR=$1
TGTUID=0
TGTUSRFILES=0
TGTUSRDIR=0
TGTUSRDIRLST=/tmp/${TGTUSR}_dir.lst
TGTUSRFILESLST=/tmp/${TGTUSR}_files.lst

# Checks that a userid was specified.
if [ ! "${TGTUSR}" ]; then
  echo "CRITICAL: No user specified."
  echo "\nUsage: $0 {user}"
  exit 1
fi

# Check that user is a valid user.
chk_usr_valid() {
  echo "- Checking if user ${TGTUSR} is valid"
  if [ `cat /etc/passwd | egrep ^${TGTUSR} | wc -l | tr -d ' '` -eq 0 ]; then
    echo "CRITICAL: User ${TGTUSR} does not exist."
    exit 1
  else
    # Obtain UID for the user.
    TGTUID=`cat /etc/passwd | egrep "^${TGTUSR}" | cut -f3 -d':'`
  fi
}

# Check for running processes.
chk_usr_procs() {
  typeset NUM_USRPROCS

  echo "- Checking for processes owned by user ${TGTUSR}"
  NUM_USRPROCS=`ps -ef | sed 's/^ *//' | awk '{ print $1 }' | grep ${TGTUSR} | wc -l | tr -d ' '`

  if [ ${NUM_USRPROCS} -gt 0 ]; then
    echo "CRITICAL: There are running processes owned by user ${TGTUSR}."
    echo "Press ENTER to view the processes."
    read TMP
    ps -ef | egrep " *${TGTUSR}"
    exit 1
  fi
}

# Check for files owned by user.
chk_usr_files() {
  echo "- Checking for directories owned by user ${TGTUSR} (note: this may take some time)"
  find / -user ${TGTUID} -type d > ${TGTUSRDIRLST}
  echo "- Checking for files owned by user ${TGTUSR} (note: this may take some time)"
  find / -user ${TGTUID} -type f > ${TGTUSRFILESLST}
  TGTUSRDIR=`cat ${TGTUSRDIRLST} | wc -l | tr -d ' '`
  TGTUSRFILES=`cat ${TGTUSRFILESLST} | wc -l | tr -d ' '`

  if [ ${TGTUSRFILES} -gt 0 ] || [ ${TGTUSRDIR} -gt 0 ]; then 
    echo "WARNING: There are ${TGTUSRFILES} files and ${TGTUSRDIR} directories owned by user ${TGTUSR}."
    echo "\nIf the user is deleted, these will become orphans."
    echo "Press ENTER to view the files and directories."
    read TMP
    cat ${TGTUSRFILESLST}
    cat ${TGTUSRDIRLST}
  fi
}

# Remove user.
del_usr() {
  typeset DATE_TODAY
  DATE_TODAY=`date '+%d%b%Y'`

  echo "- Removing user ${TGTUSR}"
  cp -p /etc/passwd /etc/passwd.${DATE_TODAY}
  cp -p /etc/shadow /etc/shadow.${DATE_TODAY}
  sed "/^${TGTUSR}:/d" /etc/passwd.${DATE_TODAY} > /etc/passwd
  sed "/^${TGTUSR}:/d" /etc/shadow.${DATE_TODAY} > /etc/shadow
}

# Remove files owned by user.
del_usr_files() {
  if [ ${TGTUSRFILES} -gt 0 ]; then
    echo "- Removing files owned by user ${TGTUSR}..."
    cat ${TGTUSRFILESLST} | while read i; do
      rm -f $i
    done
  fi
} 

# Remove directories owned by user.
del_usr_dir() {
  if [ ${TGTUSRDIR} -gt 0 ]; then
    echo "- Removing directories owned by user ${TGTUSR}..."
    cat ${TGTUSRDIRLST} | while read i; do
      rm -rf $i
    done
  fi
}


# Housekeeping
housekeep() {
  rm -f ${TGTUSRFILESLST}
  rm -f ${TGTUSRDIRLST}
}


# Main program.

# Perform checks.
chk_usr_valid
chk_usr_procs
chk_usr_files

echo "\nDo you wish to proceed? (YES to confirm)"
read TMP
if [ ! ${TMP} = "YES" ]; then
  echo "Aborted."
  exit 1
fi

del_usr
del_usr_files
del_usr_dir 
housekeep
