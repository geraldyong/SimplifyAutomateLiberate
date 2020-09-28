#!/bin/sh

OS=`uname -s`

if [ "${OS}" = "SunOS" ]; then
  echo "This is a Sun Solaris system."
elif [ "${OS}" = "Linux" ]; then
  echo "This is a Linux system."
elif [ "${OS}" = "AIX" ]; then
  echo "This is an AIX system."
elif [ "${OS}" = "HP-UX" ]; then
  echo "This is a HP-UX system."
fi
