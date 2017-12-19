#!/bin/bash
#get the unified reference system average, since it is irrelative to the temperature.

if [ $# -eq 0 ]; then
  echo "usage: Detail_Result_Files"
  exit 1
fi


echo -e "\n***************************************************************************************\n"
echo "  The program is:      "$0
echo "  The input file is:   "${1+"$@"}
echo -e "\n"

myfiles=""
for f in ${1+"$@"}; do
        myfiles="$myfiles $f"
done


awk '{
        if ( $1=="refTotalBlocks" ){
		Block = $3
	}else if ( $1=="refTotalSteps" ){
		Step = $3
	}else if ( $1=="reference" && $3=="average" ){
                TotalBlocks += Block;
                TotalSteps += Step;
                
                ref_Avg = $5
                ref_Err = $6 
                
                refS = ref_Err*ref_Err*Block*(Block-1) + ref_Avg*ref_Avg*Block;
                totSRef += refS;
                totSumRef += ref_Avg * Block;
	}
}
END {
        totSRef /= TotalBlocks;
        totSumRef /= TotalBlocks;
	
        diffRef = totSRef - totSumRef^2;

        errRef = sqrt(diffRef/(TotalBlocks-1));

	printf "        refTotalBlocks = %d\n", TotalBlocks;
        printf "        refTotalSteps = %d = %d million = %d billion\n\n", TotalSteps, TotalSteps/1000000, TotalSteps/1000000000;

        printf "        unified reference system average = %17.13e %9.3e %5.1e\n", totSumRef, errRef, errRef/sqrt(totSumRef*totSumRef);
}' $myfiles


echo -e "\n***************************************************************************************\n"
