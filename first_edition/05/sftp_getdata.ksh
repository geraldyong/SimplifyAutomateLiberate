#!/bin/ksh

SFTP=`which sftp`
SFTPUSER=geraldy
SFTPHOST=solaris1
SFTPFILE=data.txt

get_data() {
  # SFTPs the data from the remote server.
 
  $SFTP ${SFTPUSER}@${SFTPHOST} << EOF
lcd /tmp
cd scripts
mget ${SFTPFILE}
quit
EOF

  if [ $? -gt 0 ]; then
    echo "CRITICAL: Errors occurred while performing SFTP. Pls check."
    exit 1
  fi
}

# Main program.
get_data
