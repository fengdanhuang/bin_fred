#!/bin/bash

if [ $# -eq 0 ]; then
  echo "usage: CommandName Result_Files"
  exit 1
fi

#echo -e "\n***************************************************************************************\n"
#echo "  The program is:      "$0
#echo "  The input file is:   "$1
#echo -e "\n"


inputFile=$1
#echo "  inputFile= $inputFile"

awk '{
	if ( $1=="temperature" ) {
		temperature = $3;
		printf " %.5f", temperature;
	}else if ( $1=="Virial" ) {
		value = $6;
		U = $7;
		relativeU = $8;
		printf " %20.15e %10.3e %5.1e\n", value, U, relativeU;
	}
}' $inputFile
