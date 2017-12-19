#include <stdio.h>

int main(){
	printf("\n--------------------------------Data Type Test-----------------------------------------------------\n");
	printf("01.The size of int is:			%4dB, %4dbit\n",sizeof(int), sizeof(int)*8);
	printf("02.The size of unsigned int is:    	%4dB, %4dbit\n",sizeof(unsigned int), sizeof(unsigned int)*8);
	printf("03.The size of short int is:     	%4dB, %4dbit\n",sizeof(short int), sizeof(short int)*8);
	printf("04.The size of unsigned short int is:   %4dB, %4dbit\n",sizeof(unsigned short int), sizeof(unsigned short int)*8);
	printf("05.The size of long int is:   	  	%4dB, %4dbit\n",sizeof(long int), sizeof(long int)*8);
	printf("06.The size of unsigned long int is:	%4dB, %4dbit\n",sizeof(unsigned long int), sizeof(unsigned long int)*8);
	printf("07.The size of long long is:		%4dB, %4dbit\n",sizeof(long long int), sizeof(long long int)*8);
	printf("08.The size of unsigned long long is:	%4dB, %4dbit\n\n",sizeof(unsigned long long),sizeof(unsigned long long)*8);	
	printf("09.The size of float is:		%4dB, %4dbit\n",sizeof(float),sizeof(float)*8);
	printf("10.The size of double is:               %4dB, %4dbit\n",sizeof(double),sizeof(double)*8);
	printf("11.The size of long double is:          %4dB, %4dbit\n",sizeof(long double),sizeof(long double)*8);
	printf("12.The size of __float128 is:		%4dB, %4dbit\n\n",sizeof(__float128), sizeof(__float128)*8);

	printf("13.The size of char is:                 %4dB, %4dbit\n\n",sizeof(char),sizeof(char)*8);
	
	printf("01.The size of int* is:	                %4dB, %4dbit\n",sizeof(int*),sizeof(int*)*8);
	printf("02.The size of unsigned int* is:        %4dB, %4dbit\n",sizeof(unsigned int*),sizeof(unsigned int*)*8);
	printf("03.The size of short int* is:           %4dB, %4dbit\n",sizeof(short int*),sizeof(short int*)*8);
	printf("04.The size of unsigned short int* is:  %4dB, %4dbit\n",sizeof(unsigned short int*),sizeof(unsigned short int*)*8);
	printf("05.The size of long int* is:            %4dB, %4dbit\n",sizeof(long int*),sizeof(long int*)*8);
	printf("06.The size of unsigned long int* is:   %4dB, %4dbit\n",sizeof(unsigned long int*),sizeof(unsigned long int*)*8);
	printf("07.The size of long long* is:		%4dB, %4dbit\n",sizeof(long long int), sizeof(long long int)*8);
	printf("08.The size of unsigned long long* is:	%4dB, %4dbit\n",sizeof(unsigned long long*), sizeof(unsigned long long*)*8);
	printf("09.The size of float* is:               %4dB, %4dbit\n",sizeof(float*),sizeof(float*)*8);
	printf("10.The size of double* is:              %4dB, %4dbit\n",sizeof(double*),sizeof(double*)*8);
	printf("11.The size of long double* is:         %4dB, %4dbit\n",sizeof(long double*),sizeof(long double*)*8);
	printf("12.The size of char* is:                %4dB, %4dbit\n",sizeof(char*),sizeof(char*)*8);
	
	printf("\n------------------------------Variables test------------------------------------------------------------\n");
	short int si=10; int i=10; long l=10;
	float f=20; double d=20; long double ld=20;
	char ch='c'; char str[]="ABC"; char *pc=str;
	
	struct str1{
		short int si; int i; long l;
	}str_si_i_l;

	struct str2{
		float f; double d; long double ld;
	}str_f_d_ld;

	struct str3{
		char ch; char str[3]; char *pc;
	}str_char_charStr_pc;

	struct str1 *pstr1; struct str2 *pstr2; struct str3 *pstr3;
	
	printf("sizeof(si):			%4dB, %4dbit\n",sizeof(si),sizeof(si)*8);
	printf("sizeof(i):			%4dB, %4dbit\n",sizeof(i),sizeof(i)*8);
	printf("sizeof(l):			%4dB, %4dbit\n\n",sizeof(l),sizeof(l)*8);

	printf("sizeof(f):			%4dB, %4dbit\n",sizeof(f),sizeof(f)*8);
	printf("sizeof(d):			%4dB, %4dbit\n",sizeof(d),sizeof(d)*8);
	printf("sizeof(ld):			%4dB, %4dbit\n\n",sizeof(ld),sizeof(ld)*8);

	printf("sizeof(ch):			%4dB, %4dbit\n\n",sizeof(ch),sizeof(ch)*8);
	printf("Notice: The sizes of constant pointer and pointer variable are different: see below:\n");
	printf("sizeof(str):			%4dB, %4dbit\n",sizeof(str),sizeof(str)*8);
	printf("sizeof(pc):			%4dB, %4dbit\n\n",sizeof(pc),sizeof(pc)*8);
	
	//printf("sizeof(str1):			%4dB, %4dbit\n",sizeof(str1),sizeof(str1));
	printf("sizeof(str_si_i_l):		%4dB, %4dbit\n",sizeof(str_si_i_l),sizeof(str_si_i_l)*8);
	printf("sizeof(str_f_d_ld):		%4dB, %4dbit\n",sizeof(str_f_d_ld),sizeof(str_f_d_ld)*8);
	printf("sizeof(str_char_charStr_pc):	%4dB, %4dbit\n\n",sizeof(str_char_charStr_pc),sizeof(str_char_charStr_pc)*8);
	
	printf("sizeof(pstr1):			%4dB, %4dbit\n",sizeof(pstr1),sizeof(pstr1)*8);
	printf("sizeof(pstr2):			%4dB, %4dbit\n",sizeof(pstr2),sizeof(pstr2)*8);
	printf("sizeof(pstr3):			%4dB, %4dbit\n",sizeof(pstr3),sizeof(pstr3)*8);

	return 0;
}
