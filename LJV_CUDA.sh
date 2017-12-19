#!/bin/bash
#Implementation: calculate the virial coefficient by reference, reference overlap, target, target overlap through overlap sampling.
#get the result from multiple ref and target files. Accumulate their results.


if [ $# -eq 0 ]; then
  echo "usage: ScriptName Reference_Files(multiple) Target_Files(multiple)"
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
refStepSize=`grep "refStepSize =" $myfiles | head -n 1 | awk '{print $4}'`
tarStepSize=`grep "tarStepSize =" $myfiles | head -n 1 | awk '{print $4}'`
alpha=`grep "alpha =" $myfiles | head -n 1 | awk '{print $4}'`

#echo "	myfiles = $myfiles"
echo "	NOP = $NOP"
echo "	temperature = $temperature"
echo "	HSB = $HSB"
echo "	refStepSize = $refStepSize"
echo "	tarStepSize = $tarStepSize"
echo "	alpha = $alpha"
echo -e "\n"

awk -v NOP=$NOP -v temperature=$temperature -v HSB=$HSB '{
	if ( $1=="#_of_simulations" ){
		if (/reference/){
			refSimulations = $4;
		}else{
			tarSimulations = $4;
		}
	}else if ( $1=="#_of_steps" ){
		if (/reference/){
			refStep = $6;
		}else{
			tarStep = $6;
		}
	}else if ( $1=="reference" && $3=="average" ){
		refTotalSimulations += refSimulations;
		refTotalSteps += refSimulations * refStep;
		
		ref_Avg = $5
		ref_Err = $6; #use gensub() to remove parentheses.
		
		refS = ref_Err*ref_Err*refSimulations*(refSimulations-1) + ref_Avg*ref_Avg*refSimulations;
		totSRef += refS;
		totSumRef += ref_Avg * refSimulations;

	}else if ( $1=="reference" && $3=="overlap" ){		

		refOver_Avg = $6
		refOver_Err = $7; 

		refSo = refOver_Err*refOver_Err*refSimulations*(refSimulations-1) + refOver_Avg*refOver_Avg*refSimulations;
		totSORef += refSo;
		totSumORef += refOver_Avg * refSimulations;
	}else if ( $1=="reference" && $3=="correlation" ){
		refCor = $NF;
		s12Ref = refSimulations*(refCor*sqrt((refS/refSimulations - ref_Avg^2)*(refSo/refSimulations-refOver_Avg^2))+ref_Avg*refOver_Avg);
		totS12Ref += s12Ref;
		
	}else if ( $1=="Time" && $3=="ref" ){
		time_Ref += $6
	}else if ( $1=="target" && $3=="average" ){
		tarTotalSimulations += tarSimulations;
		tarTotalSteps += tarSimulations *tarStep;	

		tar_Avg = $5
		tar_Err = $6; 

		tarS = tar_Err*tar_Err*tarSimulations*(tarSimulations-1) + tar_Avg*tar_Avg*tarSimulations;
		totSTar += tarS;
		totSumTar += tar_Avg *tarSimulations;
	}else if ( $1=="target" && $3=="overlap" ){

		tarOver_Avg = $6
		tarOver_Err = $7;

		tarSo = tarOver_Err*tarOver_Err*tarSimulations*(tarSimulations-1) + tarOver_Avg*tarOver_Avg*tarSimulations;
		totSOTar += tarSo;
		totSumOTar += tarOver_Avg *tarSimulations;

	}else if ( $1=="target" && $3=="correlation" ){
		tarCor = $NF;
		s12Tar = tarSimulations*(tarCor*sqrt((tarS/tarSimulations - tar_Avg^2)*(tarSo/tarSimulations-tarOver_Avg^2))+tar_Avg*tarOver_Avg);
		totS12Tar += s12Tar;
	}else if ( $1=="Time" && $3=="tar" ){
		time_Tar += $6
	}
}
END {
	totSRef /= refTotalSimulations;
	totSumRef /= refTotalSimulations;
	totSORef /= refTotalSimulations;
	totSumORef /= refTotalSimulations;	
	totS12Ref /= refTotalSimulations

	totSTar /= tarTotalSimulations;
	totSumTar /= tarTotalSimulations;
	totSOTar /= tarTotalSimulations;
	totSumOTar /= tarTotalSimulations;
	totS12Tar /= tarTotalSimulations;
	
	diffRef = totSRef - totSumRef^2;
	diffTar = totSTar - totSumTar^2;
		
	errRef = sqrt(diffRef/(refTotalSimulations-1));
	errTar = sqrt(diffTar/(tarTotalSimulations-1));
	
	diffORef = totSORef - totSumORef^2;
	diffOTar = totSOTar - totSumOTar^2;
	
	errORef = sqrt(diffORef/(refTotalSimulations-1));
	errOTar = sqrt(diffOTar/(tarTotalSimulations-1));

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
	errRatioRef /= refTotalSimulations-1;

	errRatioTar = (totSTar/(totSumTar^2)-1) + (totSOTar/(totSumOTar^2)-1);
	errRatioTar -= 2*(totS12Tar/(totSumTar*totSumOTar)-1);
	errRatioTar /= tarTotalSimulations-1;
	
	printf "	*****Calculate virial coefficients B%d at T=%f*****\n", NOP, temperature;
	printf "	refTotalSteps = %d = %d million = %d billion\n", refTotalSteps, refTotalSteps/1000000, refTotalSteps/1000000000;
 	printf "	reference system average = %17.13e %9.3e %5.1e\n", totSumRef, errRef, errRef/sqrt(totSumRef*totSumRef); 
	printf "	reference system overlap average = %17.13e %9.3e %5.1e\n", totSumORef, errORef, errORef/totSumORef;
	printf "	reference system ratio average = %17.13e %9.3e %5.1e\n", ratioRef, sqrt(ratioRef*ratioRef*errRatioRef), sqrt(errRatioRef);
	printf "	reference system correlation = %7.3e\n\n", refCor;

	printf "	tarTotalSteps = %d = %d million = %d billion\n", tarTotalSteps, tarTotalSteps/1000000, tarTotalSteps/1000000000;
	printf "	target system average = %17.13e %9.3e %5.1e\n", totSumTar, errTar, errTar/sqrt(totSumTar*totSumTar); 
	printf "	target system overlap average = %17.13e %9.3e %5.1e\n", totSumOTar, errOTar, errOTar/totSumOTar;
	printf "	target system ratio average = %17.13e %9.3e %5.1e\n", ratioTar, sqrt(ratioTar*ratioTar*errRatioTar), sqrt(errRatioTar);
	printf " 	target system correlation = %7.3e\n\n", tarCor;
	
	totRatio = ratioTar/ratioRef;
	totErr = sqrt(errRatioRef + errRatioTar);
	B_CUDA = HSB * totRatio;
	BErr_CUDA = HSB * sqrt(totRatio^2) * totErr;
	printf "	Virial Coefficient = %20.15e %10.3e %5.1e (GPU_CUDA)\n\n\n", B_CUDA, BErr_CUDA, totErr;

	printf "	*****Reference proportion, Time and Speed*****\n";
	actual = refTotalSteps/(refTotalSteps + tarTotalSteps);
	ideal = 1/(1+sqrt(errRatioTar/errRatioRef * tarTotalSteps/refTotalSteps));
	printf "	actural reference fraction = %6.4f, ideal reference fraction = %6.4f\n", actual, ideal;	
	if (actual < ideal) printf "	Please run more steps for reference system.\n\n"
	else printf "	Please rum more steps for target system!\n\n"

	printf "	Time for ref system = %f seconds = %f minutes = %f hours = %f days. (GPU_CUDA)\n", 
				time_Ref, time_Ref/60, time_Ref/3600, time_Ref/3600/24;
	printf "	Time for tar system = %f seconds = %f minutes = %f hours = %f days. (GPU_CUDA)\n", 
				time_Tar, time_Tar/60, time_Tar/3600, time_Tar/3600/24;	
	printf "	Total execution time = %f seconds = %f minutes = %f hours = %f days. (GPU_CUDA)\n\n", 
				(time_Ref+time_Tar),
				(time_Ref+time_Tar)/60,
				(time_Ref+time_Tar)/3600,
				(time_Ref+time_Tar)/3600/24;
	speed_Ref = refTotalSteps/time_Ref;
	speed_Tar = tarTotalSteps/time_Tar;	
	printf "	Speed for ref system = %f step/second. (GPU_CUDA)\n", speed_Ref;
	printf "	Speed for tar system = %f step/second. (GPU_CUDA)\n", speed_Tar;	
	printf "	General speed = %f step/second = %f thousand_step/second = %f million_step/second. (GPU_CUDA)\n\n",
				(refTotalSteps+tarTotalSteps)/(time_Ref+time_Tar),
				(refTotalSteps+tarTotalSteps)/(time_Ref+time_Tar)/1000,
				(refTotalSteps+tarTotalSteps)/(time_Ref+time_Tar)/1000000;	
}' $myfiles


echo -e "\n***************************************************************************************\n"
