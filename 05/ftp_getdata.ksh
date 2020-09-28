#!/bin/ksh

# Note: User and password defined in $HOME/.netrc file.
FTP=`which ftp`
FTPHOST=solaris1
FTPFILE=data.txt

get_data() {
  # FTPs the data from the remote server.
 
  $FTP ${FTPHOST} << EOF
bin
hash
prompt
lcd /tmp
cd scripts
mget ${FTPFILE}
quit
EOF

  if [ $? -gt 0 ]; then
    echo "CRITICAL: Errors occurred while performing FTP. Pls check."
    exit 1
  fi
}

# Main program.
get_data
