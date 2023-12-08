#!/bin/ksh

A=10

calc() {
  B=3
  C=$(( A+B ))
  echo "$A + $B = $C"
}

# Main program.
calc
exit 0
