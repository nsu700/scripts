#!/bin/bash
obj=$1
cd $obj;find . -type f -name "*md" ! -name "SUMMARY.md" | awk -v FS="\/" 'BEGIN{print "# SUMMARY"}{split($NF,c,".");printf "* [%s](%s)\n",c[1],$0}' >$obj/SUMMARY.md