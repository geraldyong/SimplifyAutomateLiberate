#!/bin/ksh

SSH=`which ssh`
SERVER_LIST=servers.cfg
BAD_SERVERS=""

remote_exec() {
  typeset SERVER
  typeset USER
  typeset SSHCMD

  USER=$1
  SERVER=$2
  SSHCMD="$SSH -q -x -l ${USER} ${SERVER} \"ps -ef | grep httpd | wc -l | tr -d ' '\""

  echo "Results from ${USER}@${SERVER}:"
  echo "${SSHCMD}" | sh

  if [ $? -gt 0 ]; then
    echo "CRITICAL: Unable to SSH to remote server ${SERVER} as ${USER}. Pls check."
    return 1
  fi
}


# Main Program.
cat ${SERVER_LIST} | egrep -v "^&|^#" | while read i; do
  DEST_SERVER=`echo $i | cut -f1 -d':'`
  DEST_USER=`echo $i | cut -f3 -d':'`
  
  remote_exec ${DEST_USER} ${DEST_SERVER}
  if [ $? -gt 0 ]; then
    BAD_SERVERS="${BAD_SERVERS} ${DEST_SERVER}"
  fi
done

echo "\nCRITICAL: The following servers failed:"
echo ${BAD_SERVERS}
