#!/bin/ksh

SCP=`which scp`
SERVER_LIST=servers.cfg
GET_FILE=$1
PUT_FILE=$2
BAD_SERVERS=""

# Check that the file name and target path has been passed into the script.
if [ ! "${GET_FILE}" ]; then
  echo "CRITICAL: No file specified for retrieval. Pls check."
  exit 1
elif [ ! "${PUT_FILE}" ]; then
  echo "CRITICAL: No target destination specified for files retrieved. Pls check."
  exit 1
fi

retrieve_file() {
  typeset REMOTE_HOST
  typeset REMOTE_USER
  typeset REMOTE_PATH
  typeset REMOTE_FILE
  typeset LOCAL_PATH

  REMOTE_USER=$1
  REMOTE_HOST=$2
  REMOTE_PATH=`dirname $3`
  REMOTE_FILE=`basename $3`
  LOCAL_PATH=$4
  LOCAL_FILEPATH=${LOCAL_PATH}/${REMOTE_HOST}_${REMOTE_FILE}

  # Remove file from local path if it exists.
  if [ -e ${LOCAL_FILEPATH} ]; then
    echo "Removing ${LOCAL_FILEPATH}..."
    rm -f ${LOCAL_FILEPATH}
  fi

  # Copy the file from the remote server to the local server.
  # Rename the file so that the file from the next server will not overwrite
  # the file from the current server.
  echo "Retrieving ${REMOTE_PATH}/${REMOTE_FILE} from ${REMOTE_HOST}..."
  ${SCP} -p ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_PATH}/${REMOTE_FILE} ${LOCAL_FILEPATH}

  if [ $? -gt 0 ]; then
    echo "CRITICAL: Unable to SCP ${REMOTE_FILE} from remote server ${REMOTE_HOST}. Pls check."
    return 1
  fi
}


# Main Program.

# Loop through each server in the configuration file and call retrieve_file()
# to copy the file from the server.
cat ${SERVER_LIST} | egrep -v "^&|^#" | while read i; do
  DEST_SERVER=`echo $i | cut -f1 -d':'`
  DEST_USER=`echo $i | cut -f3 -d':'`
  
  retrieve_file ${DEST_USER} ${DEST_SERVER} ${GET_FILE} ${PUT_FILE} 

  if [ $? -gt 0 ]; then
    BAD_SERVERS="${BAD_SERVERS} ${DEST_SERVER}"
  fi
done

echo "\nPls obtain files from ${PUT_FILE}."

# If any servers were not successful, list them out.
if [ "${BAD_SERVERS}" ]; then
  echo "\nCRITICAL: The file was not retrieved from the following servers:"
  echo ${BAD_SERVERS}
fi
