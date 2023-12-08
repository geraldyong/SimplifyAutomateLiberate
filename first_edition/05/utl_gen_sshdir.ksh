#!/bin/ksh

USERID=`id | cut -f2 -d'(' | cut -f1 -d')'`
HOSTNAME=`hostname`

# Change to home directory.
cd ~

# Check if the .ssh directory already exists.
if [ -e .ssh ]; then
  echo "CRITICAL: .ssh directory has already been created. Pls check."
  exit 1
else
  echo "Creating .ssh directory..."
  mkdir ~/.ssh
  chmod 700 .ssh
fi

# Create the public and private keys.
echo "\nGenerating keys for ${USERID}@${HOSTNAME}..."
cd ~/.ssh
ssh-keygen -t dsa -N "" -C ${USERID}@${HOSTNAME} -f id_dsa

# Create the authorized_keys file.
echo "\nCreating authorized_keys file..."
cat id_dsa.pub >> authorized_keys
echo "------------------------------------------------------------"
cat authorized_keys
echo "------------------------------------------------------------"

echo "\nCompleted."
