awk 'BEGIN{
	for(i=0;i<20;i+=3) {
		printf "@    yaxis  tick major %d, %f\n", i,-log(10^(27-i)); 
		printf "@    yaxis  ticklabel %d, \"-10\\S%d\"\n",i,(27-i); 
		printf "@    yaxis  tick minor %d, %f\n", (i+1),-log(10^(27-i-1)); 
		printf "@    yaxis  tick minor %d, %f\n", (i+2),-log(10^(27-i-2));} 
}'

