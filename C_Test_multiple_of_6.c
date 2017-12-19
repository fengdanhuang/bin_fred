#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>


int main(int argc, char **argv){
	if (argc < 2){
		fprintf(stderr, "Usage: ProgramName input_number\n");
		_exit(1);
	}
	double input = strtod(argv[1], NULL);

	double multiple_double = (double)input/6;
	double multiple_floor = floor(multiple_double);
	double diff = multiple_double - multiple_floor;

	printf("\n****start****\n\n");	
	printf("input number = %f\n", input);
//	printf("multiple_double = %f\n", multiple_double); 
//	printf("multiple_floor = %f\n", multiple_floor);
//	printf("diff = %f\n", diff);
	printf("\n");

	if (diff < 0.5){
		printf("The closet multiple of 6 = %f\n", 6*multiple_floor);
	}else if (diff == 0.5){
		printf("The closet multiple of 6 = %f or %f\n", 
				6*multiple_floor, 6*(multiple_floor+1));
	}else {
		printf("The closet mutiple of 6 = %f\n", 6*(multiple_floor+1));
	}	
	printf("\n****end****\n");
	return 0;
}
