#!/bin/bash
# TODO
# Filter specific number
for i in {0..25};do
  line=""
  IFS="|"
  for j in {0..13}; do
    r1=$(( $RANDOM % 10 ))
    r2=$(( $RANDOM % 10 ))
    [ $r1 -eq $r2 ] && [ $r1 -eq 0 ] && continue
    line=${line}"$r1 + $r2 =  "'    '
  done
  echo $line
  echo 
done
