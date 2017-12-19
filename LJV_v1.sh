#!/bin/bash
#Implementation: calculate the virial coefficient by reference, reference overlap, target, target overlap through overlap sampling.

if [ $# -eq 0 ]; then
  echo "usage: Script_Name Reference_File Target_File"
  exit 1
fi

echo -e "\n***************************************************************************************\n"
echo "	The program is:      "$0
echo "	The input file is:   "${1+"$@"}
echo -e "\n"


myfiles=""
for f in ${1+"$@"}; do
	myfiles="$myfiles $f"
done

NOP=`grep "calculating B." $myfiles | head -n 1 | awk '{sub("B", "", $5); print $5}'`
temperature=`grep "temperature =" $myfiles | head -n 1 | awk '{print $4}'`
HSB=`grep "HSB" $myfiles | head -n 1 | awk '{print $4}'`
refStepSize=`grep "refStepSize =" $myfiles | awk '{print $4}'`
tarStepSize=`grep "tarStepSize =" $myfiles | awk '{print $4}'`
alpha=`grep "alpha =" $myfiles | head -n 1 | awk '{print $4}'`
refTotalSteps=`grep '[0-9] Monte Carlo movement for reference' $myfiles | awk '{gsub("*", "", $2); print $2}'`
tarTotalSteps=`grep '[0-9] Monte Carlo movement for target' $myfiles | awk '{gsub("*", "", $2); print $2}'`

echo "	myfiles = $myfiles"
echo "	NOP = $NOP"
echo "	temperature = $temperature"
echo "	HSB = $HSB"
echo "	refStepSize = $refStepSize"
echo "	tarStepSize = $tarStepSize"
echo "	alpha = $alpha"
echo " 	refTotalSteps = $refTotalSteps"
echo " 	tarTotalSteps = $tarTotalSteps"
echo -e "\n"

awk -v NOP=$NOP -v temperature=$temperature -v HSB=$HSB -v refTotalSteps=$refTotalSteps -v tarTotalSteps=$tarTotalSteps '{
	if ( $1=="reference" && $3=="average" ){
		ref_Avg = $5
		ref_Err = gensub("[()]", "", "g", $6); #use gensub() to remove parentheses.
		
	}else if ( $1=="reference" && $3=="overlap" ){
		refOver_Avg = $6
		refOver_Err = gensub("[()]", "", "g", $7); 
	}else if ( $1=="Time" && $3=="ref" ){
		time_Ref = $10
	}else if ( $1=="Speed" && $3=="ref" ){
		speed_Ref = $6
	}else if ( $1=="target" && $3=="average" ){
		tar_Avg = $5
		tar_Err = gensub("[()]", "", "g", $6); 
	}else if ( $1=="target" && $3=="overlap" ){
		tarOver_Avg = $6
		tarOver_Err = gensub("[()]", "", "g", $7);
	}else if ( $1=="Time" && $3=="tar" ){
		time_Tar = $10
	}else if ( $1=="Speed" && $3=="tar" ){
		speed_Tar = $6
	}
}
END {
	printf "	*****Calculate virial coefficients B%d at T=%f\n", NOP, temperature;
 	printf "	reference system average = %17.13e (%7.2e)\n", ref_Avg, ref_Err; 
	printf "	reference system overlap average = %17.13e (%7.2e)\n", refOver_Avg, refOver_Err;
	printf "	target system average = %17.13e (%7.2e)\n", tar_Avg, tar_Err; 
	printf "	target sytem overlap average = %17.13e (%7.2e)\n\n", tarOver_Avg, tarOver_Err;
	
	ratio = (tar_Avg/tarOver_Avg) * (refOver_Avg/ref_Avg);
	ratioErr = (tar_Err*tar_Err)/(tar_Avg*tar_Avg) + (ref_Err*ref_Err)/(ref_Avg*ref_Avg);
	ratioErr += (tarOver_Err*tarOver_Err)/(tarOver_Avg*tarOver_Avg) + (refOver_Err*refOver_Err)/(refOver_Avg*refOver_Avg);
	B = HSB * ratio;
	BErr = HSB * sqrt(ratio^2) * sqrt(ratioErr);
	printf "	Virial Coefficients = %17.13e %10.3e %5.1e\n\n", B, BErr, ratioErr;

	printf "	Time for ref system %f seconds. \n", time_Ref;
	printf "	Time for tar system %f seconds. \n", time_Tar;	
	printf "	Total execution time = %f seconds = %f minutes = %f hours = %f days. \n\n", 
				(time_Ref+time_Tar),
				(time_Ref+time_Tar)/60,
				(time_Ref+time_Tar)/3600,
				(time_Ref+time_Tar)/3600/24;
	
	printf "	Speed for ref system = %f step/second.\n", speed_Ref;
	printf "	Speed for tar system = %f step/second.\n", speed_Tar;	
	printf "	General speed = %f step/second = %f thousand_step/second = %f million_step/second. \n\n",
				(refTotalSteps+tarTotalSteps)/(time_Ref+time_Tar),
				(refTotalSteps+tarTotalSteps)/(time_Ref+time_Tar)/1000,
				(refTotalSteps+tarTotalSteps)/(time_Ref+time_Tar)/1000000;	
}' $myfiles


echo -e "\n***************************************************************************************\n"
