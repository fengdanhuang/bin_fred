#!/bin/bash

if [ $# -lt 2 ]; then
  echo "usage: CommandName ref_or_tar Result_Files"
  exit 1
fi


CU=$1
inputFile=$2

awk -v CU=$CU '{
	if ( $1 == "#_of_simulations") {
		NOfSimulations = $3;
		printf " %d", NOfSimulations;
		printOrNot = 1
	}else if ( $1=="Speed" && $3==CU && printOrNot==1 ) {
		tarSpeed = $6;
		printf " %f\n", tarSpeed;
		printOrNot = 0
	}
}' $inputFile
