#!/bin/bash
#Functionality: get the best alpha from 41 candidate alphas. The input is the PreAlpha.

if [ $# -eq 0 ]; then
  echo "usage: Script_Name PreAlpha(multiple files)"
  exit 1
fi

echo -e "\n***************************************************************************************\n"
echo "  The program is:      "$0
#echo "  The input file is:   "${1+"$@"}
echo -e "\n"

myfiles=""
NOfFiles=0
for f in ${1+"$@"}; do
        myfiles="$myfiles $f"
	NOfFiles=$((NOfFiles+1))
done

#Step_Block=`grep "#_of_Step_Blocks =" $myfiles | head -n 1 | awk '{print $3}'` #Notice of the output of grep.
Step_Block=`awk '{ if ( $1=="#_of_Step_Blocks" ){ print $3; exit;} }' $myfiles`
NOfSteps=`awk '{ if ( $1=="#_of_steps" ){ print $5; exit;} }' $myfiles`
temperature=`awk '{ if ( $1=="temperature" ){ print $3; exit;} }' $myfiles`
nAlpha=`awk '{ if ( $2=="candidate_alpha" ){ print $1; exit;} }' $myfiles`

#echo "  myfiles = $myfiles"
echo "    NOfFiles = $NOfFiles"
echo "    #_of_Step_Blocks per file = $Step_Block"
echo "    #_of_steps per Step_Block per file = $NOfSteps"
echo "    temperature = $temperature"
echo "    nAlpha = $nAlpha"

echo -e "\n"


awk -v NOfFiles=$NOfFiles -v Step_Block=$Step_Block -v NOfSteps=$NOfSteps -v temperature=$temperature -v nAlpha=$nAlpha '{	
	if ($2=="candidate_alpha"){
		readData=1; 
		i=0;
	}else if (readData==1){ #cannot use dollar symbol to refer variable
		alphaArray[i] = $1;
		refOver_Sum[i] += $2;
		refOver_Sqr[i] += $3;
		tarOver_Sum[i] += $4;
		tarOver_Sqr[i] += $5;
        #	printf "%20.15e %20.15e %20.15e %20.15e %20.15e\n", alphaArray[i], refOver_Sum[i], refOver_Sqr[i], tarOver_Sum[i], tarOver_Sqr[i];			
	#	print $0;
	#	print ARGV[ARGIND];
		i++;
		if(i==nAlpha){ 
			readData=0;
	#		printf "\n";
		}
	}
}END{
	printf "    %d candidate alpha:", nAlpha;
	for(i=0; i<nAlpha; i++){
		if (i%5 == 0) printf "\n     ";
		printf "%20.15e, ",alphaArray[i];	
	}
	printf "\n\n";
	
	
	refTotalSteps = NOfFiles * Step_Block * NOfSteps;
	tarBlockCount = NOfFiles * 1000;   #1000 is No. of blocks in tar system, whenever how much No. of steps based on blockSize.
	
	printf "refTotalSteps = %f\n", refTotalSteps;
	printf "tarBlockCount = %f\n", tarBlockCount;
	
	minDiffLoc = 0;
	minRatio = (refOver_Sum[0]/refTotalSteps) / (tarOver_Sum[0]/tarBlockCount);
	bias = alphaArray[0];
	minDiff = minRatio/bias + bias/minRatio - 2;
	for (i=1; i<nAlpha; i++){
		ratio = (refOver_Sum[i]/refTotalSteps) / (tarOver_Sum[i]/tarBlockCount);
#		printf "%e, %d, %e, %d\n", refOver_Sum[i], refTotalSteps, tarOver_Sum[i], tarBlockCount;	
#		printf "%e, %e\n", refOver_Sum[i]/refTotalSteps, tarOver_Sum[i]/tarBlockCount;
		bias = alphaArray[i];
		printf "%20.15e %20.15e\n", bias, ratio;
		newDiff = ratio/bias + bias/ratio - 2;
	#	printf "ratio=%f, bias=%f, newDiff=%f, minDiffLoc=%d, minDiff=%f, minRatio=%f\n", ratio, bias, newDiff, minDiffLoc, minDiff, minRatio;
		if (newDiff < minDiff){
			minDiffLoc = i;
			minDiff = newDiff;
			minRatio = ratio;
		}
	}	
		
        refOver_Avg = refOver_Sum[minDiffLoc] / refTotalSteps;
        tarOver_Avg = tarOver_Sum[minDiffLoc] / tarBlockCount;

        refOverSqr_Avg = refOver_Sqr[minDiffLoc] / refTotalSteps;
        tarOverSqr_Avg = tarOver_Sqr[minDiffLoc] / tarBlockCount;

        minRatio = refOver_Avg / tarOver_Avg;

        refOver_Err = sqrt( (refOverSqr_Avg - refOver_Avg*refOver_Avg) / ((refTotalSteps - 1)) );
        tarOver_Err = sqrt( (tarOverSqr_Avg - tarOver_Avg*tarOver_Avg) / ((tarBlockCount - 1)) );
        alpha_Err = sqrt( (refOver_Err/refOver_Avg)*(refOver_Err/refOver_Avg) + (tarOver_Err/tarOver_Avg)*(tarOver_Err/tarOver_Avg) );

        printf "\n";
        printf "    minDiffLoc = %d\n", minDiffLoc;
        printf "    Best alpha = %20.15e, new alpha = %20.15e  %10.3e %5.1e\n",
                                                alphaArray[minDiffLoc], minRatio, minRatio*alpha_Err, alpha_Err;



}' $myfiles 
