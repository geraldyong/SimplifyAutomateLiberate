# Reject login if it's a direct login.
REALUSER=`who am i | awk '{ print $1 }'`
USERID=`id | cut -f2 -d'(' | cut -f1 -d')'`

if [ "${REALUSER}" = "${USERID}" ]; then
  echo "Direct login to this account is not allowed."
  exit 1
else
  echo "User ${REALUSER} is now logged in as ${USERID}."
fi
