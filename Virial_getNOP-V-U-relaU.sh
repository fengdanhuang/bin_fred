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
	if ( $1=="NOP" ) {
		NOP = $3;
		printf " %d", NOP;
	}else if ( $1=="Virial" ) {
		value = $4;
		U = $5;
		relativeU = $6;
		printf " %20.15e %10.3e %5.1e\n", value, U, relativeU;
	}
}' $inputFile
