#!/bin/bash
#Implementation: calculate the virial coefficient by reference, reference overlap, target, target overlap through overlap sampling.
#get the result from multiple ref and target files. Accumulate their results.


if [ $# -eq 0 ]; then
  echo "usage: Script_Name CPU_Part_Result CUDA_GPU_Part_Result"
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

NOP=`grep "NOP =" $myfiles | head -n 1 | awk '{print $4}'`
temperature=`grep "temperature =" $myfiles | head -n 1 | awk '{print $4}'`
HSB=`grep "HSB" $myfiles | head -n 1 | awk '{print $4}'`
refStepSize=`grep "refStepSize =" $myfiles | head -n 1 | awk '{print $4}'`
tarStepSize=`grep "tarStepSize =" $myfiles | head -n 1 | awk '{print $4}'`
alpha=`grep "alpha =" $myfiles | head -n 1 | awk '{print $4}'`
sigmaHSRef=`grep "sigmaHSRef =" $myfiles | head -n 1 | awk '{print $4}'`

#echo "	myfiles = $myfiles"
echo "	NOP = $NOP"
echo "	temperature = $temperature"
#echo "	HSB = $HSB"
#echo "	refStepSize = $refStepSize"
#echo "	tarStepSize = $tarStepSize"
#echo "	alpha = $alpha"
#echo "	sigmaHSRef = $sigmaHSRef"
echo -e "\n"

awk -v NOP=$NOP -v temperature=$temperature -v HSB=$HSB '{
	if ( $1=="Virial" && $2=="Coefficient"){
		if (/CPU/){
			V_CPU = $4;
			U_CPU = $5;
			RU_CPU = $6;
		}else{
			V_CUDA = $4;
			U_CUDA = $5;
			RU_CUDA = $6;
		}
	}else if ( $1=="Total" && $2=="execution" && $3=="time"){
		if (/CPU/){
			Time_CPU = $5
		}else{
			Time_CUDA = $5
		}
	}	
}
END {
	
	printf "	*****Calculate virial coefficients B%d at T=%f*****\n", NOP, temperature;
	printf "	V1 = %20.15e %10.3e %5.1e (GPU CUDA)\n\n", V_CUDA, U_CUDA, RU_CUDA;
	printf "	V2 = %20.15e %10.3e %5.1e (CPU Correction)\n\n", V_CPU, U_CPU, RU_CPU;

	V = V_CPU + V_CUDA;
	U = sqrt( U_CPU^2 + U_CUDA^2 );
	RU = sqrt( (U/V)^2);
	printf "	Virial Coefficient = %20.15e %10.3e %5.1e (GPU+CPU)\n\n\n", V, U, RU;

	printf "	Total GPU CUDA time = %f seconds = %f minutes = %f hours = %f days. \n\n", 
				Time_CUDA,
				Time_CUDA/60,
				Time_CUDA/3600,
				Time_CUDA/3600/24;

	printf "	Total CPU time = %f seconds = %f minutes = %f hours = %f days. \n\n", 
				Time_CPU,
				Time_CPU/60,
				Time_CPU/3600,
				Time_CPU/3600/24;
}' $myfiles


echo -e "\n***************************************************************************************\n"
