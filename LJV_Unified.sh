#!/bin/bash
#get the virial coefficients for each temperature by using the unified reference system average value.

if [ $# -eq 0 ]; then
  echo "usage: Script_Name Unified_referecne_file Detail_result_files"
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

NOfTs=`grep "temperature =" $myfiles | wc -l`

echo "	There are $NOfTs temperatures"
echo -e "\n"


awk -v NOfTs=$NOfTs 'BEGIN{
	i = 0;
}
{
	if ( $1=="unified" ){
		ref_Avg = $6
		ref_Err = $7
		ref_Err_Rela = $7/sqrt($6*$6)
	}else if ( $1=="NOP" ){
		NOP = $3
	}else if ( $1=="temperature" ){
		temperature[i] = $3
	}else if ( $1=="HSB"){
		HSB = $3
	}else if ( $1=="refStepSize" ){
		refStepSize[i] = $3
	}else if ( $1=="tarStepSize" ){
		tarStepSize[i] = $3
	}else if ( $1=="alpha" ){
		alpha[i] = $3
	}else if ( $1=="reference" && $3=="overlap" ){
		refOver_Avg[i] = $6
		refOver_Err[i] = $7
		refOver_Err_Rela[i] = $7/sqrt($6*$6)
	}else if ( $1=="target" && $3=="average" ){
		tar_Avg[i] = $5
		tar_Err[i] = $6
		tar_Err_Rela[i] = $6/sqrt($5*$5)
	}else if ( $1=="target" && $3=="overlap" ){
		tarOver_Avg[i] = $6
		tarOver_Err[i] = $7
		tarOver_Err_Rela[i] = $7/sqrt($6*$6)
	}else if ( $1=="target" && $3=="ratio" ){
		ratioTar[i] = $6
		ratioTar_Err[i] = $7
		ratioTar_Err_Rela[i] = $7/sqrt($6*$6)
		
		i++;
	}
		
}
END{
	for (i=0; i<NOfTs; i++){
		printf "\n***************************************************************************************\n\n"
		printf "	NOP = %d\n", NOP;
		printf "	temperature = %f\n", temperature[i];
		printf "	HSB = %f\n", HSB;
		printf "	refStepSize = %f\n", refStepSize[i];
		printf "	tarStepSize = %f\n", tarStepSize[i];
		printf "	alpha = %f\n\n", alpha[i];
	
		ratioRef[i] = ref_Avg/refOver_Avg[i];
		ratioTar[i] = tar_Avg[i]/tarOver_Avg[i];

		errRatioRef[i] = ref_Err_Rela^2 + refOver_Rela[i]^2;
		errRatioTar[i] = ratioTar_Err_Rela[i]^2;
			
		printf "	reference system average = %17.13e %9.3e %5.1e\n", ref_Avg, ref_Err, ref_Err_Rela;
		printf "  	reference system overlap average = %17.13e %9.3e %5.1e\n", refOver_Avg[i], refOver_Err[i], refOver_Err_Rela[i];
		printf "	reference system ratio average = %17.13e %9.3e %5.1e\n\n", ratioRef[i], sqrt(ratioRef[i]*ratioRef[i]*errRatioRef[i]), sqrt(errRatioRef[i]);

		printf "	target system average = %17.13e %9.3e %5.1e\n", tar_Avg[i], tar_Err[i], tar_Err_Rela[i];
		printf "	target system overlap average = %17.13e %9.3e %5.1e\n", tarOver_Avg[i], tarOver_Err[i], tarOver_Err_Rela[i];
		printf "	target system ratio average = %17.13e %9.3e %5.1e\n\n", ratioTar[i], sqrt(ratioTar[i]*ratioTar[i]*errRatioTar[i]), sqrt(errRatioTar[i]);

		totRatio[i] = ratioTar[i]/ratioRef[i];	
		totErr[i] = sqrt(errRatioRef[i] + errRatioTar[i]);	
		B[i] = HSB * totRatio[i];
		BErr[i] =HSB * sqrt(totRatio[i]^2) * totErr[i];

		printf "	Virial Coefficients = %20.15e %10.3e %5.1e\n", B[i], BErr[i], totErr[i];
		printf "\n***************************************************************************************\n"
	}

}' $myfiles


echo -e "\n***************************************************************************************\n"


