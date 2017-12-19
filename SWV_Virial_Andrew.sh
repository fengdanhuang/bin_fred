#!/bin/bash
#Usage: 
#	get the fraction contribution for virial coefficient of square well.
#Input: 
#	Result file including value, and uncertainty (This is Andrew, lambda=1.5, unreduced or reduced results)
#Ouput: 
#	multiple files. Each file representing the contribution of one coefficients under many temperature points.

if [ $# -eq 0 ]; then
  echo "usage: Script_Name Result_Files"
  exit 1
fi

echo -e "\n***************************************************************************************\n"
echo "	The program is:      "$0
#echo "	The input file is:   "${1+"$@"}
echo -e "\n"


myfiles=""
for f in ${1+"$@"}; do
	myfiles="$myfiles $f"
done
myfileLine=`wc -l $myfiles | awk '{print $1}'`
echo " myfileLine = $myfileLine"

awk -v myfileLine=$myfileLine 'BEGIN{
	i = 0; read = 1;
}{
	if (read == 1){
		a[i] = $2
		Err[i] = $3
#		printf "------%e %e\n", a[i], Err[i];
		
		i++;
		if (i==myfileLine){
			read = 0;
		}
	}
}END{
	for(T=1.0; T<=2.0; T+=0.01){
		y = exp(1/T) - 1;
#		printf "---%f  %e\n", T, y;

		VSW = 0;
		for (i=0; i<myfileLine; i++){
			VSW += a[i]*(y^i);
		}
#		printf "---VSW=%f\n", VSW;
		
		printf "	%f	%e\n", T, VSW >> "T-VSW.txt"
#		ESum = 0;
#		for (i=0; i<myfileLine; i++){
#			ESum += Err[i]^2
	}

	for(y=-2.0; y<=2.0; y+=0.01){

		VSW = 0;
		for (i=0; i<myfileLine; i++){
			VSW += a[i]*(y^i);
		}
#		printf "---VSW=%f\n", VSW;
		printf "	%e	%e\n", y, VSW >> "y-VSW.txt"		
	}
	
}' $myfiles


echo -e "\n***************************************************************************************\n"
