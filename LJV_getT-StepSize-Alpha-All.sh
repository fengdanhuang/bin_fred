#!/bin/bash

if [ $# -lt 1 ]; then
  echo "usage: CommandName Result_Files"
  exit 1
fi
 
inputFile=${*} #get all the parameters from 2nd to last.
#echo -e "\n***************************************************************************************\n"
#echo "  The program is:      "$0
#echo "  Parameter= $Para"
#echo "  inputFile= $inputFile"
#echo -e "\n"

awk '{
	if ( $8 == "temperature" ){
		T = $9
		printf " %f", T;
	}else if ( $1=="refStepSize" && $4=="tarStepSize"){
		refStep = $3
		tarStep = $6
		printf " %f %f", refStep, tarStep;
	}else if ( $1=="alphaArray[0]" ){
		alpha0 = $3
		printf " %.15f\n", alpha0;
	}
}' $inputFile
