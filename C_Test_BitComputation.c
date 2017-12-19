#include <stdio.h>

#define NOP 4
#define NF (1 << NOP)

int main(int argc, char **argv){

	int x1 = 12;
	printf("int x=%d\n", x1);
	printf("-x=%d\n", -x1);
	printf("~x=%d\n", ~x1);
	
	unsigned int x2 = 12;
	printf("unsigned int x=%d\n", x2);
	printf("-x=%u\n", -x2);
	printf("~x=%u\n\n", ~x2);

	printf("NOP = %d(%x)\n", NOP, NOP);
	printf("NF = %d(%x)\n\n", NF, NF);
	
	for (int i=0; i<NOP; i++){
		int result_LeftShift = 1<<i; // 1 left shift for i bits.
		printf("1<<%d(1<<%x)=%d(%x)\n",i,i,result_LeftShift,result_LeftShift);
	}
	printf("\n");

	for (int i=0; i<NOP; i++)
		for (int j=i+1; j<NOP; j++){
			int result_2 = 1<<i|1<<j;
			printf("1<<%d|1<<%d (1<<%x|1<<%x) = %d(%x)\n", 
				   i,j,i,j,result_2,result_2);
		}
	printf("\n");

	for (int i=3; i<NF; i++){
		int j = i & -i;
		printf(" %d & -%d = %d (%x & -%x = %x) \n", i, i, j, i, i, j);
		if (i == j) continue;
		int k = i & ~j;
		printf("~%d = %d, %d & ~%d = %d\n", j, ~j, i, j, k);
	}
	printf("\n");

	for (int i=1; i<NF; i++){
		int iLowBit = i & -i;
		printf(" %d & -%d = %d (%x & -%x = %x) \n", i, i, iLowBit, i, i, iLowBit);
		int inc = iLowBit<<1;
		printf(" %d<<1 = %d (%x<<1=%x) \n", iLowBit, inc, iLowBit, inc);
		for (int j=iLowBit; j<i; j+=inc){
			int jComp = i & ~j;
			printf("     %d & ~%d = %d (%x & ~%x = %x)\n",i,~j,iLowBit,
								      i,~j,iLowBit);
		}
	}
	printf("\n");	
	return 0;
}
