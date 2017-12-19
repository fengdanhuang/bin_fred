#!/bin/bash

if [ $# -lt 2 ]; then
  echo "usage: CommandName parameter(temperature, refStepSize, tarStepSize, alpha) Result_Files"
  exit 1
fi

Para=$1 
inputFile=${*:2} #get all the parameters from 2nd to last.
#echo -e "\n***************************************************************************************\n"
#echo "  The program is:      "$0
#echo "  Parameter= $Para"
#echo "  inputFile= $inputFile"
#echo -e "\n"

awk -v Para=$Para '{
	if ( Para == "temperature" && $8 == "temperature" ){
		T = $9
		printf " %f", T;
	}else if ( Para == "refStepSize" && $1=="refStepSize" ){
		refStep = $3
		printf " %f", refStep;
	}else if ( Para == "tarStepSize" && $4=="tarStepSize" ){
		tarStep = $6
		printf " %f", tarStep;	
	}else if ( Para == "alpha" && $1=="alphaArray[0]" ){
		alpha0 = $3
		printf " %f", alpha0;
	}
}
END{
	printf "\n";
}' $inputFile
