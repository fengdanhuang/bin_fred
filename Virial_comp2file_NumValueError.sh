#!/bin/bash
#This file is mainly used in evaluation of Andrew's results in the project of 
#Square Well potential coefficients Evaluation.

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
	Ordinal[i] = $1;
	v[i] = $2;
	e[i] = $3;
	i++;
}END{
#	printf "%d\n", NR;
	for (i=0; i<NR; i++){
		printf "%d %e %e\n", i, v[i], e[i];
	}

	for (i=0; i<(NR/2); i++){
		numerator = v[i] - v[i+NR/2];
		denominator = sqrt(e[i]^2+e[i+NR/2]^2);
		if (denominator != 0){
			result = numerator /denominator;
		}else{
			result = 0;
		}

		printf "	%d  %20.15e  %5.3e   %20.15e   %5.3e 	%7f\n", 
				i, v[i], e[i], v[i+NR/2], e[i+NR/2], result;		
#		printf "%d %5f ", i, numerator;
#		printf "%5f ", denominator;
#		printf "%5f\n", result;	
	}
}' $file1 $file2	
