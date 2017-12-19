#!/bin/bash
#Implementation: calculate the virial coefficient by reference, reference overlap, target, target overlap through overlap sampling.
#get the result from multiple ref and target files. Accumulate their results.


if [ $# -eq 0 ]; then
  echo "usage: Script_Name Reference_Files(multiple) Target_Files(multiple)"
  exit 1
fi

echo -e "\n***************************************************************************************\n"
echo "	The program is:      "$0
#echo "	The input file is:   "${1+"$@"}
echo -e "\n"


myfiles=""
for f in ${1+"$@"}; do
	myfiles="$myfiles $f"
done

NOP=`grep "calculating B." $myfiles | head -n 1 | awk '{sub("B", "", $5); print $5}'`
NPAIRS=$(($NOP*($NOP-1)/2))
NOfCor=$((($NPAIRS+1)*$NPAIRS/2))
temperature=`grep "temperature =" $myfiles | head -n 1 | awk '{print $4}'`
HSB=`grep "HSB" $myfiles | head -n 1 | awk '{print $4}'`
refStepSize=`grep "refStepSize =" $myfiles | head -n 1 | awk '{print $4}'`
tarStepSize=`grep "tarStepSize =" $myfiles | head -n 1 | awk '{print $4}'`
alpha=`grep "alpha =" $myfiles | head -n 1 | awk '{print $4}'`
sigmaSW=`grep "sigmaSW =" $myfiles | head -n 1 | awk '{print $4}'`
lamda=`grep "lamda =" $myfiles | head -n 1 | awk '{print $4}'`
sigmaHSRef=`grep "sigmaHSRef =" $myfiles | head -n 1 | awk '{print $4}'`

#echo "	myfiles = $myfiles"
echo "	NOP = $NOP"
echo "	NPAIRS = $NPAIRS"
echo "	NOfCor = $NOfCor (# of correlation between coefficients)"
echo "	temperature = $temperature"
echo "	HSB = $HSB"
echo "	refStepSize = $refStepSize"
echo "	tarStepSize = $tarStepSize"
echo "	alpha = $alpha"
echo "	sigmaSW = $sigmaSW"
echo "	lamda = $lamda"
echo "	sigmaHSRef = $sigmaHSRef"
echo -e "\n"

awk -v NOP=$NOP -v NPAIRS=$NPAIRS -v NOfCor=$NOfCor -v temperature=$temperature -v HSB=$HSB '{
	if ( $1=="#_of_blocks" ){
		if (/reference/){
			refBlock = $3;
		}else{
			tarBlock = $3;
		}
	}else if ( $1=="#_of_refTotalSteps" ){
		refStep = $3;
	}else if ( $1=="#_of_tarTotalSteps" ){
		tarStep = $3;
	}else if ( $1=="reference" && $3=="average" ){
		refTotalBlocks += refBlock;
		refTotalSteps += refStep;
		
		ref_Avg = $5
		ref_Err = gensub("[()]", "", "g", $6); #use gensub() to remove parentheses.
		
		refS = ref_Err*ref_Err*refBlock*(refBlock-1) + ref_Avg*ref_Avg*refBlock;
		totSRef += refS;
		totSumRef += ref_Avg * refBlock;

	}else if ( $1=="reference" && $3=="overlap" ){		

		refOver_Avg = $6
		refOver_Err = gensub("[()]", "", "g", $7); 

		refSo = refOver_Err*refOver_Err*refBlock*(refBlock-1) + refOver_Avg*refOver_Avg*refBlock;
		totSORef += refSo;
		totSumORef += refOver_Avg * refBlock;
	}else if ( $1=="reference" && $3=="correlation" ){
		refCor = $NF;
		s12Ref = refBlock*(refCor*sqrt((refS/refBlock - ref_Avg^2)*(refSo/refBlock-refOver_Avg^2))+ref_Avg*refOver_Avg);
		totS12Ref += s12Ref;
		
	}else if ( $1=="Time" && $3=="ref" ){
		time_Ref += $10
	}else if ( $1=="target" && $3=="average" ){
		tarTotalBlocks += tarBlock;
		tarTotalSteps += tarStep;	
		
		readAvg=1;
		i=0;
	}else if (readAvg==1){
		tar_Avg[i] = $1
		tar_Err[i] = gensub("[()]", "", "g", $2); 

		tarS[i] = tar_Err[i]*tar_Err[i]*tarBlock*(tarBlock-1) + tar_Avg[i]*tar_Avg[i]*tarBlock;

#		printf "------%e %e %e\n", tar_Avg[i], tar_Err[i], tarS[i];
		totSTar[i] += tarS[i];
		totSumTar[i] += tar_Avg[i] *tarBlock;
		i++;
		if (i== NPAIRS+1){
			readAvg = 0;
		}
	}else if ( $1=="target" && $3=="overlap" ){

		tarOver_Avg = $6
		tarOver_Err = gensub("[()]", "", "g", $7);

		tarSo = tarOver_Err*tarOver_Err*tarBlock*(tarBlock-1) + tarOver_Avg*tarOver_Avg*tarBlock;
		totSOTar += tarSo;
		totSumOTar += tarOver_Avg *tarBlock;

	}else if ( $1=="target" && $3=="correlation" ){
		readCorrelation =1;
		j=0;
	}else if (readCorrelation==1){
		
		tarCor[j] = $1;
		s12Tar[j] = tarBlock*(tarCor[j]*sqrt((tarS[j]/tarBlock - tar_Avg[j]^2)*(tarSo/tarBlock-tarOver_Avg^2))+tar_Avg[j]*tarOver_Avg);
		totS12Tar[j] += s12Tar[j];
		j++;
		if (j==NPAIRS+1){
			readCorrelation = 0;
		}
	}else if ( $1=="expectation" && $2=="between" ){
		read_EB = 1;
		k=0;
	}else if (read_EB==1){
		tar_AvgIJ[k] = $2;
		totSumTarIJ[k] += tar_AvgIJ[k] * tarBlock;
		k++;
		if (k==NOfCor){
			read_EB = 0;
		}
	}else if ( $1=="Time" && $3=="tar" ){
		time_Tar += $10
	}
}
END {
	totSRef /= refTotalBlocks;
	totSumRef /= refTotalBlocks;
	totSORef /= refTotalBlocks;
	totSumORef /= refTotalBlocks;	
	totS12Ref /= refTotalBlocks

	totSOTar /= tarTotalBlocks;
	totSumOTar /= tarTotalBlocks;
	
	diffRef = totSRef - totSumRef^2;
	errRef = sqrt(diffRef/(refTotalBlocks-1));
	diffORef = totSORef - totSumORef^2;
	errORef = sqrt(diffORef/(refTotalBlocks-1));
	ratioRef = totSumRef/totSumORef;

	diffOTar = totSOTar - totSumOTar^2;
	errOTar = sqrt(diffOTar/(tarTotalBlocks-1));

	corRef = 0;
	if (diffRef * diffORef > 0){
		corRef = (totS12Ref - totSumRef*totSumORef/sqrt(diffRef*diffORef));
	} 

	errRatioRef = (totSRef/(totSumRef^2)-1) + (totSORef/(totSumORef^2)-1);
	errRatioRef -= 2*(totS12Ref/(totSumRef*totSumORef)-1);
	errRatioRef /= refTotalBlocks-1;
	
	for(i=0; i<=NPAIRS; i++){
#		printf "---%e\n", totSTar[i];
		totSTar[i] /= tarTotalBlocks;
		totSumTar[i] /= tarTotalBlocks;
		totS12Tar[i] /= tarTotalBlocks;
		diffTar[i] = totSTar[i] - totSumTar[i]^2;
		errTar[i] = sqrt(diffTar[i]/(tarTotalBlocks-1));
		ratioTar[i] = totSumTar[i]/totSumOTar;
		
		if (diffTar[i] * diffOTar > 0){
			corTar[i] = (totS12Tar[i] - totSumTar[i]*totSumOTar/sqrt(diffTar[i]*diffOTar));
		}else{
			corTar[i] = 0;
		}

		errRatioTar[i] = (totSTar[i]/(totSumTar[i]^2)-1) + (totSOTar/(totSumOTar^2)-1);
		errRatioTar[i] -= 2*(totS12Tar[i]/(totSumTar[i]*totSumOTar)-1);
		errRatioTar[i] /= tarTotalBlocks-1;	
	}
	
	printf "	*****Calculate virial coefficients B%d at T=%f*****\n", NOP, temperature;
	printf "	refTotalBlocks = %d\n", refTotalBlocks;
	printf "	refTotalSteps = %d = %f million = %f billion\n", refTotalSteps, refTotalSteps/1000000.0, refTotalSteps/1000000000.0;
 	printf "	reference system average = %17.13e %9.3e %5.1e\n", totSumRef, errRef, errRef/sqrt(totSumRef*totSumRef); 
	printf "	reference system overlap average = %17.13e %9.3e %5.1e\n", totSumORef, errORef, errORef/totSumORef;
	printf "	reference system ratio average = %17.13e %9.3e %5.1e\n", ratioRef, sqrt(ratioRef*ratioRef*errRatioRef), sqrt(errRatioRef);
	printf "	reference system correlation = %7.3e\n\n", refCor;

	printf "	tarTotalBlocks = %d\n", tarTotalBlocks;
	printf "	tarTotalSteps = %d = %f million = %f billion\n", tarTotalSteps, tarTotalSteps/1000000.0, tarTotalSteps/1000000000.0;
	printf "	target system average = \n";

	for (i=0; i<=NPAIRS; i++){
		printf "		%17.13e %9.3e %5.1e\n", totSumTar[i], errTar[i], errTar[i]/sqrt(totSumTar[i]*totSumTar[i]); 
	}
	printf "	target system overlap average = %17.13e %9.3e %5.1e\n", totSumOTar, errOTar, errOTar/totSumOTar;
	printf "	target system ratio average = \n";
	for (i=0; i<=NPAIRS; i++){
		printf "		%17.13e %9.3e %5.1e\n", ratioTar[i], sqrt(ratioTar[i]*ratioTar[i]*errRatioTar[i]), sqrt(errRatioTar[i]);
	}
	printf " 	target system correlation = \n";
	for (i=0; i<=NPAIRS; i++){
		printf "		%7.3e\n", tarCor[i];
	}
	
	totalSteps = refTotalSteps + tarTotalSteps;
        printf "\n        Total Steps = %d = %f million = %f billion\n\n", totalSteps, totalSteps/1000000.0, totalSteps/1000000000.0;

	printf "	Virial Coefficient = \n";
	for (i=0; i<=NPAIRS; i++){	
		totRatio[i] = ratioTar[i]/ratioRef;
		totErr[i] = sqrt(errRatioRef + errRatioTar[i]);
		B[i] = HSB * totRatio[i];
		BErr[i] = HSB * sqrt(totRatio[i]^2) * totErr[i];
		printf "	%3d   %20.15e %10.3e %5.1e (CPU)\n", i, B[i], BErr[i], totErr[i];
		printf "	%20.15e %10.3e %5.1e \n", B[i], BErr[i], totErr[i] > "ValueErr_B"NOP"_ByBlock.txt";

		printf "	%3d   %20.10e\n", i, BErr[i]*sqrt(time_Ref+time_Tar) > "Difficulty_B"NOP"_ByBlock.txt";

#		printf "	%20.15e %10.3e %5.1e \n", B[i], BErr[i], totErr[i];
	}

	printf "\n	Correlation between coefficients (Sampling by block)= \n";
	k = 0;
	for (i=0; i<NPAIRS; i++)
		for (j=i+1; j<=NPAIRS; j++){
			totSumTarIJ[k] /= tarTotalBlocks;
			covariance = totSumTarIJ[k] - totSumTar[i]*totSumTar[j];	
			varianceI = totSTar[i] - totSumTar[i]^2;
			varianceJ = totSTar[j] - totSumTar[j]^2;		
			corBB[k] = covariance / sqrt( varianceI * varianceJ );

#			printf "%d  %25.15e %25.15e %25.15e\n", tarTotalBlocks, totSumTarIJ[k], totSumTar[i], totSumTar[j];
#                       printf "%d  %25.15e %25.15e\n", tarTotalBlocks, totSTar[i], totSTar[j];
#                       printf "covariance=%e\n", covariance;
#                       printf "varianceI=%e\n", varianceI;
#                       printf "varianceJ=%e\n", varianceJ;
 
			printf "	%3d   %25.15e between B%d[%d] and B%d[%d]\n", 
					k, corBB[k], NOP, i, NOP, j;
			printf "	      %25.15e\n", corBB[k]> "Correlation_B"NOP"_ByBlock.txt";
			k++;
		}
		
	printf "\n	*****Reference proportion, Time and Speed*****\n";
	actual = refTotalSteps/(refTotalSteps + tarTotalSteps);
		
	for (i=0; i<=NPAIRS; i++){
		if(errRatioRef == 0) idea[i] = 0;	
		else ideal[i] = 1/(1+sqrt(errRatioTar[i]/errRatioRef * tarTotalSteps/refTotalSteps));
		printf "	%3d   actural reference fraction = %6.4f, ideal reference fraction = %6.4f\n", i, actual, ideal[i];	
		if (actual < ideal[i]) printf "	     Please run more steps for reference system!\n"
		else printf "	     Please rum more steps for target system!\n"
	}
	printf("\n");
	
	printf "	Time for ref system = %f seconds = %f minutes = %f hours = %f days. (CPU)\n", 
				time_Ref, time_Ref/60, time_Ref/3600, time_Ref/3600/24;
	printf "	Time for tar system = %f seconds = %f minutes = %f hours = %f days. (CPU)\n", 
				time_Tar, time_Tar/60, time_Tar/3600, time_Tar/3600/24;	
	printf "	Total execution time = %f seconds = %f minutes = %f hours = %f days. (CPU)\n\n", 
				(time_Ref+time_Tar),
				(time_Ref+time_Tar)/60,
				(time_Ref+time_Tar)/3600,
				(time_Ref+time_Tar)/3600/24;
	speed_Ref = refTotalSteps/time_Ref;
	speed_Tar = tarTotalSteps/time_Tar;	
	printf "	Speed for ref system = %f step/second. (CPU)\n", speed_Ref;
	printf "	Speed for tar system = %f step/second. (CPU)\n", speed_Tar;	
	printf "	General speed = %f step/second = %f thousand_step/second = %f million_step/second. (CPU)\n\n",
				(refTotalSteps+tarTotalSteps)/(time_Ref+time_Tar),
				(refTotalSteps+tarTotalSteps)/(time_Ref+time_Tar)/1000,
				(refTotalSteps+tarTotalSteps)/(time_Ref+time_Tar)/1000000;	
	
}' $myfiles


echo -e "\n***************************************************************************************\n"
