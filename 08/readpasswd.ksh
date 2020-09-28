#!/bin/ksh

echo "Password not hidden"
echo "-------------------"
echo "Pls enter your password:"
read PASSWD
echo "You entered $PASSWD."

echo "\nPassword hidden"
echo "---------------"
echo "Pls enter your password:"
stty -echo
read PASSWD2
stty echo
echo "You entered $PASSWD2."
