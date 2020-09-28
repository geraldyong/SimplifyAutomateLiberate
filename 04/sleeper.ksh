#!/bin/ksh

i=0

while [ i -lt 10 ]; do
  i=$(( i + 1 ))
  echo "[$$] Waiting... i = $i..."
  sleep 1
done

echo "Completed."
