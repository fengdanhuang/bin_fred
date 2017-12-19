#!/bin/bash

if [ $# -lt 2 ]; then
  echo "usage: Command_Name file1 file2"
  exit 1
fi

echo -e "\n***************************************************************************************\n"
echo "  The program is:      "$0
echo "  The input file is:   "${1+"$@"}
echo -e "\n"

file1=$1
file2=$2

awk 'BEGIN{
	i=0;
}{
	co[i] = $1;
	i++;
}END{
#	printf "%d\n", NR;
#	for (i=0; i<NR; i++){
#		printf " %e \n", i, co[i];
#	}

	for (i=0; i<(NR/2); i++){
		diff = co[i] - co[i+NR/2];

		printf "	%d  %20.15e   %20.15e   %7f\n", 
				i, co[i], co[i+NR/2], diff;		
#		printf "%d %5f ", i, numerator;
#		printf "%5f ", denominator;
#		printf "%5f\n", result;	
	}
}' $file1 $file2	
