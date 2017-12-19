#!/bin/bash

if [ $# -lt 3 ]; then
  echo "usage: CommandName Threads_Per_Block ref_or_tar Result_Files"
  exit 1
fi


TPB=$1
CU=$2
inputFile=$3
#echo -e "\n***************************************************************************************\n"
#echo "  The program is:      "$0
#echo "  Threads per block = $TPB"
#echo "  System = $CU"
#echo "  inputFile= $inputFile"
#echo -e "\n"

awk -v TPB=$TPB -v CU=$CU '{
	if ( $5 == TPB && $6=="threads/block") {
		NOfSimulations = $8;
		printf " %d", NOfSimulations;
		printOrNot = 1
	}else if ( $1=="Speed" && $3==CU && printOrNot==1 ) {
		tarSpeed = $6;
		printf " %f\n", tarSpeed;
		printOrNot = 0
	}
}' $inputFile
