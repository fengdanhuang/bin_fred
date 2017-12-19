#!/bin/sh


if [ $# -lt 2 ]; then
	echo "Usage: Script_Name Value_Error_File Correlation_File"
	exit 1
fi


#input_File=B_l1.5.dat
#if [ -e Bcor_l1.5.dat ]; then
#  input_File="B_l1.5.dat Bcor_l1.5.dat"
#fi

n=`pwd | sed -e 's#.*B##;s#^\([0-9]*\).*#\1#'`
input_File=$1" "$2
inCorFile=$2

echo "n = $n"
echo "input_File=$input_File"

awk -v n=$n -v inCorFile=$inCorFile '{
	if (ARGV[ARGIND]==inCorFile) {
		hascor=1;
    		for (i=2; i<=NF; i++) {
      			bcor[$1,i-2]=$i;
    		}
  	}else {
    		b[$1]=$2;
    		eb[$1]=$3;
    		nj=$1;
  	}
}END{
	outB=sprintf("B%d.dat", n);
  	outBy=sprintf("B%d_y.dat", n);
  
  	for (T=0.5; T<10; T+=0.01) {
    		be=1/T;
    		y=exp(be)-1;
    		B=0;
    		tB=0;
    		eB=0;
    		for (j=0; j<=nj; j++) {
      			B+=b[j]*y^j;
      			tB+=(b[j]*b[j])^.5*y^j;
      			Bj[j]=b[j]*y^j;
      			eBj[j]=eb[j]^2*y^(2*j);
      			eB+=eb[j]^2*y^(2*j);
      			if (hascor) {
        			for (k=j+1; k<=nj; k++) {
          				eB+=2*eb[j]*eb[k]*bcor[j,k]*y^(k+j);
        			}
      			}
    		}
    		printf "%5.2f %21.15e %10.4e\n", T, B, sqrt(eB) > outB;
  	}

  	for (y=-1; y<4; y+=0.01) {
    		B=0;
    		tB=0;
    		eB=0;
    		for (j=0; j<=nj; j++) {
      			B+=b[j]*y^j;
      			tB+=(b[j]*b[j])^.5*y^j;
      			Bj[j]=b[j]*y^j;
      			eBj[j]=eb[j]^2*y^(2*j);
      			eB+=eb[j]^2*y^(2*j);
      			if (hascor) {
        			for (k=j+1; k<=nj; k++) {
          				eB+=2*eb[j]*eb[k]*bcor[j,k]*y^(k+j);
        			}
      			}
    		}
    		printf "%5.2f %21.15e %10.4e\n", y, B, sqrt(eB) > outBy;
  	}
}' $input_File
