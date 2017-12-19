
#include <stdio.h>

int main(int argc, char**argv){
	int a;
	int i, j, k;
	for (a=0; a<100; a++)
		for (i=40; i<=47; i++)
			for (j=30; j<=37; j++)
				for (k=1; k<=9; k++)
					printf("\e[%d;%d;%dm Hello World. i=%d,j=%d,k=%d\e[0m \r",i,j,k,i,j,k);
	
	return 0;
}
