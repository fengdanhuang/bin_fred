#!/bin/bash
# show the first line of multiple files

if [ $# -eq 0 ]; then
  echo "usage: Script_Name Files(multiple)"
  exit 1
fi

echo -e "\n***************************************************************************************\n"
echo "  The program is:      "$0
#echo " The input file is:   "${1+"$@"}
echo -e "\n"

myfiles=""
for f in ${1+"$@"}; do
        myfiles="$myfiles $f"
done

#echo $myfiles

head -n 1 $myfiles
