#!/bin/bash
#Implementation: calculate the virial coefficient by reference, reference overlap, target, target overlap through overlap sampling.
#get the result from multiple ref and target files. Accumulate their results.

#The purpose of this script is to take each job(file, simulation) as a block, and recalculate the uncertainty. Because these block would be more independent.
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
temperature=`grep "temperature =" $myfiles | head -n 1 | awk '{print $4}'`
HSB=`grep "HSB" $myfiles | head -n 1 | awk '{print $4}'`
#refStepSize=`grep "refStepSize =" $myfiles | head -n 1 | awk '{print $4}'`
tarStepSize=`grep "tarStepSize =" $myfiles | head -n 1 | awk '{print $4}'`
alpha=`grep "alpha =" $myfiles | head -n 1 | awk '{print $4}'`
sigmaHSRef=`grep "sigmaHSRef =" $myfiles | head -n 1 | awk '{print $4}'`

#echo "	myfiles = $myfiles"
echo "	NOP = $NOP"
echo "	temperature = $temperature"
echo "	HSB = $HSB"
#echo "	refStepSize = $refStepSize"
echo "	tarStepSize = $tarStepSize"
echo "	alpha = $alpha"
echo "	sigmaHSRef = $sigmaHSRef"
echo -e "\n"

awk -v NOP=$NOP -v temperature=$temperature -v HSB=$HSB '{
	if ( $1=="#_of_Step_Blocks" ){
			tarStepBlock = $3;
	}else if ( $1=="#_of_steps" ){
			tarStep = $5;
	}else if ( $1=="refTotalSteps" ){
			refSteps = $3;
	}else if ( $1=="reference" && $3=="average" ){
		refTotalSteps += refSteps;
		
		ref_Avg = $5
		ref_Err = gensub("[()]", "", "g", $6); #use gensub() to remove parentheses.
		
		refS = ref_Err*ref_Err*refSteps*(refSteps-1) + ref_Avg*ref_Avg*refSteps;
		totSRef += refS;
		totSumRef += ref_Avg * refSteps;

	}else if ( $1=="reference" && $3=="overlap" ){		

		refOver_Avg = $6
		refOver_Err = gensub("[()]", "", "g", $7); 

		refSo = refOver_Err*refOver_Err*refSteps*(refSteps-1) + refOver_Avg*refOver_Avg*refSteps;
		totSORef += refSo;
		totSumORef += refOver_Avg * refSteps;
	}else if ( $1=="reference" && $3=="correlation" ){
		refCor = $NF;
		s12Ref = refSteps*(refCor*sqrt((refS/refSteps - ref_Avg^2)*(refSo/refSteps-refOver_Avg^2))+ref_Avg*refOver_Avg);
		totS12Ref += s12Ref;
		
	}else if ( $1=="Time" && $3=="ref" ){
		time_Ref += $10
	}else if ( $1=="target" && $3=="average" ){
		tarTotalBlocks += 1;
		tarTotalSteps += tarStepBlock *tarStep;	

		tar_Avg = $5
		tar_Err = gensub("[()]", "", "g", $6); 

		tarS = tar_Err*tar_Err*1*(1-1) + tar_Avg*tar_Avg*1; # 1 simulation as 1 block
		totSTar += tarS;
		totSumTar += tar_Avg *1;
	}else if ( $1=="target" && $3=="overlap" ){

		tarOver_Avg = $6
		tarOver_Err = gensub("[()]", "", "g", $7);

		tarSo = tarOver_Err*tarOver_Err*1*(1-1) + tarOver_Avg*tarOver_Avg*1; # 1 simulation as 1 block
		totSOTar += tarSo;
		totSumOTar += tarOver_Avg *1;

	}else if ( $1=="target" && $3=="correlation" ){
		tarCor = $NF;
		s12Tar = 1*(tarCor*sqrt((tarS/1 - tar_Avg^2)*(tarSo/1-tarOver_Avg^2))+tar_Avg*tarOver_Avg);
		totS12Tar += s12Tar;
	}else if ( $1=="Time" && $3=="tar" ){
		time_Tar += $10
	}
}
END {
	totSRef /= refTotalSteps;
	totSumRef /= refTotalSteps;
	totSORef /= refTotalSteps;
	totSumORef /= refTotalSteps;	
	totS12Ref /= refTotalSteps

	totSTar /= tarTotalBlocks;
	totSumTar /= tarTotalBlocks;
	totSOTar /= tarTotalBlocks;
	totSumOTar /= tarTotalBlocks;
	totS12Tar /= tarTotalBlocks;
	
	diffRef = totSRef - totSumRef^2;
	diffTar = totSTar - totSumTar^2;
		
	errRef = sqrt(diffRef/(refTotalSteps-1));
	errTar = sqrt(diffTar/(tarTotalBlocks-1));
	
	diffORef = totSORef - totSumORef^2;
	diffOTar = totSOTar - totSumOTar^2;
	
	errORef = sqrt(diffORef/(refTotalSteps-1));
	errOTar = sqrt(diffOTar/(tarTotalBlocks-1));

	ratioRef = totSumRef/totSumORef;
	ratioTar = totSumTar/totSumOTar;

	corRef = 0;
	corTar = 0;
	if (diffRef * diffORef > 0){
		corRef = (totS12Ref - totSumRef*totSumORef/sqrt(diffRef*diffORef));
	} 
	if (diffTar * diffOTar > 0){
		corTar = (totS12Tar - totSumTar*totSumOTar/sqrt(diffTar*diffOTar));
	}	

	errRatioRef = (totSRef/(totSumRef^2)-1) + (totSORef/(totSumORef^2)-1);
	errRatioRef -= 2*(totS12Ref/(totSumRef*totSumORef)-1);
	errRatioRef /= refTotalSteps-1;

	errRatioTar = (totSTar/(totSumTar^2)-1) + (totSOTar/(totSumOTar^2)-1);
	errRatioTar -= 2*(totS12Tar/(totSumTar*totSumOTar)-1);
	errRatioTar /= tarTotalBlocks-1;
	
	printf "	*****Calculate virial coefficients B%d at T=%f*****\n", NOP, temperature;
	printf "	refTotalSteps = %d = %f million = %f billion\n", refTotalSteps, refTotalSteps/1000000.0, refTotalSteps/1000000000.0;
 	printf "	reference system average = %17.13e %9.3e %5.1e\n", totSumRef, errRef, errRef/sqrt(totSumRef*totSumRef); 
	printf "	reference system overlap average = %17.13e %9.3e %5.1e\n", totSumORef, errORef, errORef/totSumORef;
	printf "	reference system ratio average = %17.13e %9.3e %5.1e\n", ratioRef, sqrt(ratioRef*ratioRef*errRatioRef), sqrt(errRatioRef);
	printf "	reference system correlation = %7.3e\n\n", refCor;

	printf "	tarTotalBlocks = %d\n", tarTotalBlocks;
	printf "	tarTotalSteps = %d = %f million = %f billion\n", tarTotalSteps, tarTotalSteps/1000000.0, tarTotalSteps/1000000000.0;
	printf "	target system average = %17.13e %9.3e %5.1e\n", totSumTar, errTar, errTar/sqrt(totSumTar*totSumTar); 
	printf "	target system overlap average = %17.13e %9.3e %5.1e\n", totSumOTar, errOTar, errOTar/totSumOTar;
	printf "	target system ratio average = %17.13e %9.3e %5.1e\n", ratioTar, sqrt(ratioTar*ratioTar*errRatioTar), sqrt(errRatioTar);
	printf " 	target system correlation = %7.3e\n\n", tarCor;

	totalSteps = refTotalSteps + tarTotalSteps;
        printf "        Total Steps = %d = %f million = %f billion\n\n", totalSteps, totalSteps/1000000.0, totalSteps/1000000000.0;
	
	totRatio = ratioTar/ratioRef;
	totErr = sqrt(errRatioRef + errRatioTar);
	B = HSB * totRatio;
	BErr = sqrt(HSB^2 * totRatio^2) * totErr;
	printf "	Virial Coefficients = %20.15e %10.3e %5.1e\n\n\n", B, BErr, totErr;

	printf "	*****Reference proportion, Time and Speed*****\n";
	actual = refTotalSteps/(refTotalSteps + tarTotalSteps);
	ideal = 1/(1+sqrt(errRatioTar/errRatioRef * tarTotalSteps/refTotalSteps));
	printf "	actural reference fraction = %6.4f, ideal reference fraction = %6.4f\n", actual, ideal;	
	if (actual < ideal) printf "	Please run more steps for reference system.\n\n"
	else printf "	Please rum more steps for target system!\n\n"

	printf "	Time for ref system = %f seconds = %f minutes = %f hours = %f days. \n", 
				time_Ref, time_Ref/60, time_Ref/3600, time_Ref/3600/24;
	printf "	Time for tar system = %f seconds = %f minutes = %f hours = %f days. \n", 
				time_Tar, time_Tar/60, time_Tar/3600, time_Tar/3600/24;	
	printf "	Total execution time = %f seconds = %f minutes = %f hours = %f days. \n\n", 
				(time_Ref+time_Tar),
				(time_Ref+time_Tar)/60,
				(time_Ref+time_Tar)/3600,
				(time_Ref+time_Tar)/3600/24;
	speed_Ref = refTotalSteps/time_Ref;
	speed_Tar = tarTotalSteps/time_Tar;	
	printf "	Speed for ref system = %f step/second.\n", speed_Ref;
	printf "	Speed for tar system = %f step/second.\n", speed_Tar;	
	printf "	General speed = %f step/second = %f thousand_step/second = %f million_step/second. \n\n",
				(refTotalSteps+tarTotalSteps)/(time_Ref+time_Tar),
				(refTotalSteps+tarTotalSteps)/(time_Ref+time_Tar)/1000,
				(refTotalSteps+tarTotalSteps)/(time_Ref+time_Tar)/1000000;	
}' $myfiles


echo -e "\n***************************************************************************************\n"
