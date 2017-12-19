#!/bin/bash


if [ $# -lt 4 ]; then
  echo "usage: Command_Name Value1 Uncertainty1 Value2 Uncertainty2"
  exit 1
fi

echo -e "\n***************************************************************************************\n"
echo "	The program is:      "$0
#echo "	The input file is:   "${1+"$@"}
echo -e "\n"


v1=$1
e1=$2
v2=$3
e2=$4
echo "	The 1st value is:	$v1   $e1"
echo "	The 2nd value is:	$v2   $e2"

awk -v v1=$v1 -v e1=$e1 -v v2=$v2 -v e2=$e2 'BEGIN{
	numerator = v1-v2;
	denominator = sqrt(e1^2+e2^2);
	result = numerator / denominator;
	printf "\n	The difference over square root of sqare sum = %5.4f\n", result;
}'
