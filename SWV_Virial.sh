#!/bin/bash
#Implementation: calculate virial coefficient B(T) of square well potential by the expansion:
#   B(T) = a_0 + a_1 * y(T) + a_2 * y^2(T) + a_3 * y^3(T) + ... + a_n * y^n(T).

#Input File:
#	Only one, which is the reslt file including coefficients of square well.


if [ $# -eq 0 ]; then
  echo "usage: Script_Name Result_File(only one)"
  exit 1
fi

echo -e "\n***************************************************************************************\n"
echo "	The program is:      "$0
echo -e "\n"


myfiles=$1
NOP=`grep "NOP = " $myfiles | head -n 1 | awk '{print $3}'`
NPAIRS=$(($NOP*($NOP-1)/2))
NOfCor=$((($NPAIRS+1)*$NPAIRS/2))
sigmaSW=`grep "sigmaSW =" $myfiles | head -n 1 | awk '{print $NF}'`
lamda=`grep "lamda =" $myfiles | head -n 1 | awk '{print $NF}'`
sigmaHSRef=`grep "sigmaHSRef =" $myfiles | head -n 1 | awk '{print $NF}'`
chainFrac=`grep "chainFrac =" $myfiles | head -n 1 | awk '{print $3}'`
treeFrac=`grep "treeFrac =" $myfiles | head -n 1 | awk '{print $3}'`
ringFrac=`grep "ringFrac =" $myfiles | head -n 1 | awk '{print $3}'`

echo "	myfiles = $myfiles"
echo "	NOP = $NOP"
echo "	NPAIRS = $NPAIRS"
echo "	NOfCor = $NOfCor (# of correlation between coefficients)"
echo "	sigmaSW = $sigmaSW"
echo "	lamda = $lamda"
echo "	sigmaHSRef = $sigmaHSRef"
echo
echo "	chainFrac = $chainFrac"
echo "	treeFrac = $treeFrac"
echo "	ringFrac = $ringFrac"

awk -v NOP=$NOP -v NPAIRS=$NPAIRS -v NOfCor=$NOfCor -v NOP=$NOP -v chainFrac=$chainFrac -v treeFrac=$treeFrac -v ringFrac=$ringFrac '{

	if ( $1=="Total" && $2=="Steps" ){
		totalSteps = $4;
	}else if ( $1=="Virial" && $2=="Coefficient" ){	
		readCoeff=1;
		i=0;
	}else if (readCoeff==1){
		a[i] = $2
		Err[i] = $3;
		relaErr[i] = $4;
#		printf "------%d %e %e %e\n", i, a[i], Err[i], relaErr[i];
		i++;
		if (i== NPAIRS+1){
			readCoeff = 0;
		}

	}else if ( $1=="Correlation"){
		readCorrelation =1;
		j=0;
	}else if (readCorrelation==1){		
		CorBB[j] = $2;
#		printf "======%d %e \n", j, CorBB[j];
		j++;
		if (j==NOfCor){
			readCorrelation = 0;
		}
	}
}END{
        printf "        Total Steps = %d = %f million = %f billion\n\n", totalSteps, totalSteps/1000000.0, totalSteps/1000000000.0;

	printCC = 0;
	if (printCC==1){
		printf "        Coefficient a[i] = \n";
        	for(i=0; i<=NPAIRS; i++){
                	printf "        %20.15e %10.3e %5.1e \n",a[i], Err[i], relaErr[i];
		}
       		printf "\n      Correlation between coefficients = \n";
        	k = 0;
        	for (i=0; i<NPAIRS; i++){
                	for (j=i+1; j<=NPAIRS; j++){
                        	printf "        %3d   %25.15e between a[%d] and a[%d]\n", 
                                        	k, CorBB[k], i, j;
                        	k++;
                	}
  		}
	}

	for(T=0.6; T<=5; T+=0.1){

		Y_Value = exp(1/T) - 1;
		printf "  Y(%d) = %f\n", T, Y_Value;		


		B = 0;
		USqr = 0; USqr1 = 0; USqr2 = 0;
		for(i=0; i<=NPAIRS; i++){
#			printf " a[%d] = %f, Y_Value = %f\n", i, a[i], Y_Value;
			B += a[i] * Y_Value^i;
			USqr1 += Err[i]^2 * (Y_Value^i)^2;
		}
		U1 = sqrt(USqr1);
		printf "   Virial Coefficient B%d(%.1f) without correlation = %20.15e %10.5e %5.2e\n", 
						NOP, T, B, U1, U1/sqrt(B*B);
	
		k = 0;
		for (i=0; i<NPAIRS; i++){
			for (j=i+1; j<=NPAIRS; j++){
				USqr2 += 2 * (Y_Value^i) * (Y_Value^j) * CorBB[k] * Err[i] * Err[j];
			}
		}
		USqr = USqr1 + USqr2;
		U = sqrt(USqr);
		printf "   Virial Coefficient B%d(%.1f) with correlation = %20.15e %10.5e %5.2e\n\n", 
						NOP, T, B, U, U/sqrt(B*B);
		
		printf "	%.1f	%10.5e	%10.5e %10.4e\n", T, U1, U, U1/U >> "B"NOP"_T_UNoCor_UCor.txt"		
	}
	printf("\n");	
}' $myfiles


echo -e "\n***************************************************************************************\n"
