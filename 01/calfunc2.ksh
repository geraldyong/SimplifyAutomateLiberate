#!/bin/ksh

A=10

calc() {
  typeset B
  typeset C
  B=$1

  C=$(( A+B ))
  echo "$A + $B = $C"
}

# Main program.
calc 40
exit 0
