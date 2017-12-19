#!/bin/bash
# show the ith line of multiple files

if [ $# -eq 0 ]; then
  echo "usage: Script_Name i(the ith line) Files(multiple)"
  exit 1
fi

echo -e "\n***************************************************************************************\n"
echo "  The program is:      "$0
echo "	The line number which need to be showed:      "$1
#echo " The input file is:   "${2+"$@"}
echo -e "\n"

myfiles=""
for f in ${2+"${@:2}"}; do
        myfiles="$myfiles $f"
done

echo $myfiles

awk -v i=$1 '{if(FNR == i) print}' $myfiles
