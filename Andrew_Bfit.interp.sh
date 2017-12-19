#!/bin/sh

base=`echo $0 | sed -e 's#.*/##;s#.dat.interp$##'`
N=`echo $base | sed -e 's#[A-Za-z]##g'`
awk -v T=$1 -v N=$N '{
  if (NR==1) {
    a0=$2;
    Y=exp($2/sqrt(T))-1;
    sum=0;
    dsum=0;
    BSS[3]=3.79106644;
    BSS[4]=3.52761;
    BSS[5]=2.11494;
    BSS[6]=0.76953;
    BSS[7]=0.09043;
    BSS[8]=-0.0742;
    BSS[9]=-0.035;
    BSS[9]=0.040;

  }
  else if ($1!="check:") {
    sum += $2*Y^($1+1);
    if ($1>0) dsum += $1*$2*Y^($1-1);
  }
}
END {
#  printf "N=%d\n", N;	
  sum += BSS[N];
  sum *= (T/4)^(-(N-1)/4);	
  printf "%s %22.15e %22.15e\n", T, sum, -dsum*a0/T^2*exp(a0/T);
}' ${base}Y.fit
