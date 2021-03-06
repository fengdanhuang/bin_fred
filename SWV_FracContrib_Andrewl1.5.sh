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
		printf "------%e %e\n", a[i], Err[i];
		
		i++;
		if (i==myfileLine){
			read = 0;
		}
	}
}END{
	for(T=0.6; T<10; T+=0.1){
		y = exp(1/T) - 1;
#		printf "---%f  %e\n", T, y;

		VSum = 0;
		for (i=0; i<myfileLine; i++){
			VSum += sqrt(a[i]*(y^i) * a[i]*(y^i));
		}
		printf "---VSum=%f\n", VSum;
		for(i=0; i<myfileLine; i++){
			printf "  %d  %e\n", i, a[i]*(y^i);
			Vfraction = a[i]*(y^i)/VSum;
			printf "  %f  %e\n", T, Vfraction> "a"i"_Vfraction.txt";
		}

#		ESum = 0;
#		for (i=0; i<myfileLine; i++){
#			ESum += Err[i]^2
	}
	

}' $myfiles


echo -e "\n***************************************************************************************\n"
