#!/bin/bash

#Functionality: Transfer Wheatley's reduced results to unreduced results.

if [ $# -lt 2 ]; then
  echo "usage: Command_Name Wheatley_file order lamda"
  exit 1
fi

echo -e "\n***************************************************************************************\n"
echo "  The program is:      "$0
echo "  The Wheatley's result file is:	 " $1
echo -e "\n"

file1=$1
order=$2
lamda=$3

M_PI=3.14159265358979323846
sigmaHSRef=1.0 #Wheatley specially use this value.

echo "	NOP = $order"
echo "	lamda = $lamda"
echo "	M_PI = $M_PI"
echo "	sigmaHSRef = $sigmaHSRef"
echo -e "\n"

awk -v order=$order -v lamda=$lamda -v M_PI=$M_PI -v sigmaHSRef=$sigmaHSRef 'BEGIN {
	i = 0;
	HSB2 = 2.0 * M_PI / 3.0 * sigmaHSRef * sigmaHSRef * sigmaHSRef;
	printf "	HSB2 = %f\n\n", HSB2;
}{
	if ($1 != "Power"){
		v[i] = $2;
		e[i] = $3;
#		printf " %e %e\n", v[i], e[i];
		i++;
	}
}END{
#	printf "%d\n", NR;
	printf "	The original data from Wheatley file:\n"
#	TotalLines=NR-1;
	TotalLines=NR;	#Note: if there is a head line, use NR-1; Otherwise, use NR.
	for (i=0; i<TotalLines; i++){
		printf "	%d %e %e\n", i, v[i], e[i];
	}
	
	printf "\n\n	The coefficients got from original data are:\n"
	printf "		HSB2^(order-1) = %e\n", HSB2^(order-1);
	for (i=0; i<TotalLines; i++){
		printf "	%d %e %e\n", i, v[i]*HSB2^(order-1), e[i]*HSB2^(order-1);
		printf "	%e %e\n", v[i]*HSB2^(order-1), e[i]*HSB2^(order-1)>"WheatleyTransfer_B"order"_l"lamda".txt";
	}
		
}' $file1
