#!/bin/bash

if [ $# -eq 0 ]; then
  echo "usage: Script_Name GPU_Ref_System_Avg B9_T5.0_CPU_Correction_original"
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

awk '{
	if ( $1=="GPU" && $3=="reference" ){
		ref_Avg = $7
		ref_Err = $8
		ref_Err_Rela = $8/sqrt($7*$7)
	}else if ( $1=="NOP" ){
		NOP = $3
	}else if ( $1=="temperature" ){
		temperature = $3
	}else if ( $1=="HSB"){
		HSB = $3
	}else if ( $1=="refStepSize" ){
		refStepSize = $3
	}else if ( $1=="tarStepSize" ){
		tarStepSize = $3
	}else if ( $1=="alpha" ){
		alpha = $3
	}else if ( $1=="reference" && $3=="overlap" ){
		refOver_Avg = $6
		refOver_Err = $7
		refOver_Err_Rela = $7/sqrt($6*$6)
	}else if ( $1=="target" && $3=="average" ){
		tar_Avg = $5
		tar_Err = $6
		tar_Err_Rela = $6/sqrt($5*$5)
	}else if ( $1=="target" && $3=="overlap" ){
		tarOver_Avg = $6
		tarOver_Err = $7
		tarOver_Err_Rela = $7/sqrt($6*$6)	
        }else if ( $1=="target" && $3=="ratio" ){
                ratioTar = $6
                ratioTar_Err = $7
                ratioTar_Err_Rela = $7/sqrt($6*$6)
        }
}
END{
	printf "\n***************************************************************************************\n\n"
	printf "	NOP = %d\n", NOP;
	printf "	temperature = %f\n", temperature;
	printf "	HSB = %f\n", HSB;
	printf "	refStepSize = %f\n", refStepSize;
	printf "	tarStepSize = %f\n", tarStepSize;
	printf "	alpha = %f\n\n", alpha;
	
	ratioRef = ref_Avg/refOver_Avg;
	ratioTar = tar_Avg/tarOver_Avg;

	errRatioRef = ref_Err_Rela^2 + refOver_Rela^2;
	errRatioTar = ratioTar_Err_Rela^2;
			
	printf "	reference system average = %17.13e %9.3e %5.1e\n", ref_Avg, ref_Err, ref_Err_Rela;
	printf "  	reference system overlap average = %17.13e %9.3e %5.1e\n", refOver_Avg, refOver_Err, refOver_Err_Rela;
	printf "	reference system ratio average = %17.13e %9.3e %5.1e\n\n", ratioRef, sqrt(ratioRef*ratioRef*errRatioRef), sqrt(errRatioRef);

	printf "	target system average = %17.13e %9.3e %5.1e\n", tar_Avg, tar_Err, tar_Err_Rela;
	printf "	target system overlap average = %17.13e %9.3e %5.1e\n", tarOver_Avg, tarOver_Err, tarOver_Err_Rela;
	printf "	target system ratio average = %17.13e %9.3e %5.1e\n\n", ratioTar, sqrt(ratioTar*ratioTar*errRatioTar), sqrt(errRatioTar);

	totRatio = ratioTar/ratioRef;	
	totErr = sqrt(errRatioRef + errRatioTar);	
	B = HSB * totRatio;
	BErr =HSB * sqrt(totRatio^2) * totErr;

	printf "	Virial Coefficient = %20.15e %10.3e %5.1e (CPU)\n", B, BErr, totErr;
	printf "\n***************************************************************************************\n"
}' $myfiles


echo -e "\n***************************************************************************************\n"


