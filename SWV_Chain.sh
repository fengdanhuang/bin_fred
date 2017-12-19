#!/bin/bash
#Implementation: calculate the coefficient of square well by Wheatley Extension and reference chain.
#get the result from multiple sample files. Accumulate their results.


if [ $# -eq 0 ]; then
  echo "usage: Script_Name Files(multiple)"
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
NOP=`grep "Calculate B." $myfiles | head -n 1 | awk '{sub("B", "", $2); print $2}'`
NPAIRS=$(($NOP*($NOP-1)/2))
NOfCor=$((($NPAIRS+1)*$NPAIRS/2))
temperature=`grep "temperature =" $myfiles | head -n 1 | awk '{print $NF}'`
HSB=`grep "HSB" $myfiles | head -n 1 | awk '{print $NF}'`
sigmaSW=`grep "sigmaSW =" $myfiles | head -n 1 | awk '{print $NF}'`
lamda=`grep "lamda =" $myfiles | head -n 1 | awk '{print $NF}'`
Y_Value=`grep "Y_Value =" $myfiles | head -n 1 | awk '{print $NF}'`
sigmaHSRef=`grep "sigmaHSRef =" $myfiles | head -n 1 | awk '{print $NF}'`

echo "	myfiles = $myfiles"
echo "	NOP = $NOP"
echo "	NPAIRS = $NPAIRS"
echo "	NOfCor = $NOfCor (# of correlation between coefficients)"
echo "	temperature = $temperature"
echo "	HSB = $HSB"
echo "	sigmaSW = $sigmaSW"
echo "	lamda = $lamda"
echo "	Y_Value = $Y_Value"
echo "	sigmaHSRef = $sigmaHSRef"
echo -e "\n"

awk -v NOP=$NOP -v NPAIRS=$NPAIRS -v NOfCor=$NOfCor -v temperature=$temperature -v HSB=$HSB -v Y_Value=$Y_Value '{
	if ( $1=="#_of_totalSteps" ){
		steps = $3;
	}else if ( $1=="Time" && $2=="for" ){
		totalTime += $6
	}else if ( $1=="coefficients" && $2 == "=" ){	
		totalSteps += steps;
		readAvg=1;
		i=0;
	}else if (readAvg==1){
		Avg[i] = $1;
		Err[i] = gensub("[()]", "", "g", $2); 
		Avg[i] /= HSB;
		Err[i] /= HSB;
		S[i] = Err[i]*Err[i]*steps*(steps-1) + Avg[i]*Avg[i]*steps;
#		printf "------%e %e %e\n", Avg[i], Err[i], S[i];

		totS[i] += S[i];
		totSum[i] += Avg[i]*steps;

		i++;
		if (i== NPAIRS+1){
			readAvg = 0;
		}

	}else if ( $1=="correlation" && $3=="between" ){
		readCorrelation =1;
		j=0;
	}else if (readCorrelation==1){		
		Cor[j] = $1;
#		s12[j] = steps*(Cor[j]*sqrt((S[j]/steps - Avg[j]^2)*(tarSo/tarBlock-tarOver_Avg^2))+tar_Avg[j]*tarOver_Avg);
#		totS12Tar[j] += s12Tar[j];
		j++;
		if (j==NPAIRS+1){
			readCorrelation = 0;
		}
	}else if ( $1=="expectation" && $2=="between" ){
		read_EB = 1;
		k=0;
	}else if (read_EB==1){
		AvgIJ[k] = $2;
		totSumIJ[k] += AvgIJ[k] * steps;
		k++;
		if (k==NOfCor){
			read_EB = 0;
		}
	}
}END{
	
	printf "	*****Calculate virial coefficients B%d at T=%f*****\n", NOP, temperature;

        printf "\n        Total Steps = %d = %f million = %f billion\n\n", totalSteps, totalSteps/1000000.0, totalSteps/1000000000.0;

	printf "	Virial Coefficient = \n";
	for(i=0; i<=NPAIRS; i++){
#		printf "---%e\n", totS[i];
		totS[i] /= totalSteps;

		totSum[i] /= totalSteps;
		diff[i] = totS[i] - totSum[i]^2;
		totErr[i] = sqrt(diff[i]/(totalSteps-1));
#		printf "	%d %e\n", totalSteps, totSum[i];
		if(totSum[i] !=0){
			relatTotErr[i] = totErr[i]/ sqrt(totSum[i]*totSum[i]);
		}else{
			relatTotErr[i] = 0;
		}
#		printf "	%3d   %20.15e %10.3e %5.1e (CPU)\n", i, totSum[i], totErr[i], relatTotErr[i];

		a[i] = totSum[i] / (Y_Value^i);
		aErr[i] = totErr[i] / (Y_Value^i);		
		printf "	%3d   %20.15e %10.3e %5.1e (CPU)\n", i, a[i]*HSB, aErr[i]*sqrt(HSB^2), relatTotErr[i];
		printf "	%20.15e %10.3e %5.1e \n", a[i]*HSB, aErr[i]*sqrt(HSB^2), relatTotErr[i] > "ValueErr_B"NOP".txt";
		
#		printf "        %3d   %20.10e\n", i, aErr[i]*sqrt(HSB^2) * sqrt(totalTime) > "Difficulty_Chain_B"NOP".txt";
		printf "        %3d   %20.10e\n", i, aErr[i]*sqrt(HSB^2) * sqrt(totalTime) > "Difficulty_ChainTree_B"NOP".txt";
	
	}
	
	printf "\n	Correlation between coefficients (Sampling by block)= \n";
	k = 0;
	for (i=0; i<NPAIRS; i++)
		for (j=i+1; j<=NPAIRS; j++){
			totSumIJ[k] /= totalSteps;
			covariance = totSumIJ[k] - totSum[i]*totSum[j];	
			varianceI = totS[i] - totSum[i]^2;
			varianceJ = totS[j] - totSum[j]^2;	
			if(varianceI*varianceJ !=0){	
				corBB[k] = covariance / sqrt( varianceI * varianceJ );
			}else{
				corBB[k] = 0;
			}

#			printf "%d  %25.15e %25.15e %25.15e\n", totalSteps, totSumIJ[k], totSum[i], totSum[j];
#                       printf "%d  %25.15e %25.15e\n", totalSteps, totS[i], totS[j];
#                       printf "covariance=%e\n", covariance;
#                       printf "varianceI=%e\n", varianceI;
#                       printf "varianceJ=%e\n", varianceJ;
 
			printf "	%3d   %25.15e between B%d[%d] and B%d[%d]\n", 
					k, corBB[k], NOP, i, NOP, j;
			printf "	      %25.15e\n", 
					corBB[k], NOP, i, NOP, j > "Correlation_B"NOP".txt";
			k++;
		}
				
	printf("\n");	
	printf "	Total execution time = %f seconds = %f minutes = %f hours = %f days. (CPU)\n\n", 
				totalTime,
				totalTime/60,
				totalTime/3600,
				totalTime/3600/24;
	speed = totalSteps/totalTime;
	printf "	General speed = %f step/second = %f thousand_step/second = %f million_step/second. (CPU)\n\n",
				speed,
				speed/1000,
				speed/1000000;	
}' $myfiles


echo -e "\n***************************************************************************************\n"
