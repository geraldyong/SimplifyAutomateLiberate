#!/bin/ksh

ls -R | grep "^\." | sed -e 's~:$~~' -e 's~[^/]*/~   ~g' -e 's~[^ ]~|--&~'
