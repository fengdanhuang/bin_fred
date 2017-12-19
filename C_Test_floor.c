#include <stdio.h>
#include <stdlib.h>
#include <math.h>


int main(int argc, char **argv){
	if(argc<2){
		printf("Usage: CommandName number\n");
		exit(1);
	} 
	double x = strtod(argv[1], NULL);
	printf("floor(%f)=  %f\n", x, floor(x));
	return 0;
}
