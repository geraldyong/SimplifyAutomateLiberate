#!/bin/ksh

cat /etc/passwd | cut -f1 -d':' | while read i; do 
  echo $i `finger $i | egrep "On since|Never|Last login" | tail -1`
done
