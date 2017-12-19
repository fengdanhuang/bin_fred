#!/bin/bash
#Calculate the difficulties of the coefficients for Andrew's result at lambda=1.5
#Input: 2 files
#	Time File, including the running time.
#	Value_Error_File, including the values and error of the coefficients.
#
#Output: 1 file
#	Difficulty file, including the difficulty of the coefficients.


if [ $# -lt 3 ]; then
  echo "usage: Script_Name order Time_File Value_Error_File"
  exit 1
fi

echo -e "\n***************************************************************************************\n"
echo "	The program is:      "$0
echo -e "\n"

order=$1
time_File=$2
value_File=$3
days=`cat $time_File`
value_FileLine=`wc -l $value_File | awk '{print $1}'`

echo "	order = $order"
echo "	time_File = $time_File"
echo "	value_File = $value_File"
echo "	days = $days"
echo "	value_FileLine = $value_FileLine"

awk -v order=$order -v days=$days -v value_FileLine=$value_FileLine 'BEGIN{
	i = 0; read = 1;
}{
	serialNo[i] = $1;
	value[i] = $2;	
	Err[i] = $3;
#	printf "	%d %e %e\n", i, value[i], Err[i];
	i++;
	
	if (i==value_FileLine){
		read = 0;
	}
}END{
	time = days*24*3600;
	for(i=0; i<value_FileLine; i++){
		Difficulty[i] = sqrt(time) * Err[i];
		printf "	%d	%e\n", i, Difficulty[i] > "B"order"_Difficulty.txt";
		DifficultyIndex[i] = log(Difficulty[i] / sqrt(value[i]*value[i])) / log(10);
		printf "	%d	%e\n", i, DifficultyIndex[i] > "B"order"_DiffiIndex.txt";
	}
}' $value_File


echo -e "\n***************************************************************************************\n"
