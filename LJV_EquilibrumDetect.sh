#!/bin/bash
#Functionality: detect the best number of steps for equilibrum, by plot #_of_steps vs. tar_BlockSum and #_of_steps vs tarOver_BlockSum.

if [ $# -eq 0 ]; then
  echo "usage: EquilibrumDetect.sh Index_tarBlockSum_tarOverBlockSum(multiple files)"
  exit 1
fi

#echo -e "\n***************************************************************************************\n"
#echo "  The program is:      "$0
#echo "  The input file is:   "${1+"$@"}
#echo -e "\n"

myfiles=""
NOfFiles=0
for f in ${1+"$@"}; do
        myfiles="$myfiles $f"
	NOfFiles=$((NOfFiles+1))
done

Step_Block=`grep "#_of_Step_Blocks =" $myfiles | head -n 1 | awk '{print $3}'` #Notice of the output of grep.
Step_Block=`awk '{ if ( $1=="#_of_Step_Blocks" ){ print $3; exit;} }' $myfiles`
NOfSteps=`awk '{ if ( $1=="#_of_steps" ){ print $5; exit;} }' $myfiles`
temperature=`awk '{ if ( $1=="temperature" ){ print $3; exit;} }' $myfiles`

#echo "  myfiles = $myfiles"
echo "    NOfFiles = $NOfFiles"
echo "    #_of_Step_Blocks per file = $Step_Block"
echo "    #_of_steps per Step_Block per file = $NOfSteps"
echo "    temperature = $temperature"

#echo -e "\n"


awk -v NOfFiles=$NOfFiles -v Step_Block=$Step_Block -v NOfSteps=$NOfSteps -v temperature=$temperature '{	
	if ($1=="Step_Index"){
		readData=1; 
		i=0;
	}else if (readData==1){ #cannot use dollar symbol to refer variable
		myIndex[i] = $1;
		tar_BlockSum[i] += $2;
		tarOver_BlockSum[i] += $3;
	#      	printf "%d %20.15e\n", myIndex, tar_BlockSum;		
	#      	printf "%d %20.15e\n", myIndex, tarOver_BlockSum;		
	#	printf $0;  printf "\n";	
		i++;
		if(i==1000){ 
			readData=0;
	#		printf "\n";
		}
	}
}END{
	for (i=0; i<1000; i++){
		tar_BlockSum[i] /= NOfFiles;	#get the average among all the jobs.	
		tarOver_BlockSum[i] /= NOfFiles;
		printf "%d %20.15e \n", myIndex[i], tar_BlockSum[i] > "Step_vs_tarBlockAvg.txt";
		printf "%d %20.15e \n", myIndex[i], tarOver_BlockSum[i] > "Step_vs_tarOverBlockAvg.txt";
	}
}' $myfiles 
