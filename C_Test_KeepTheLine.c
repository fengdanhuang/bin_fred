#include <stdio.h>

int main(int argc, char **argv){
	int i;
	printf("\e[31;47m Hello World! \e[0m \n");
	for (i=0; i<1000000; i++){
		printf("|\r");
		printf("/\r");
		printf("-\r");
	}	
	return 0;
}
