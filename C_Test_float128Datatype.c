#include <stdio.h>

int main(int argc, char** argv) {

  	fprintf(stdout, "sizeof(float)=%d\n", sizeof(float));
	float foo_float = 1.0Q;//Quad(128 bits) Constant
  	float bar_float = 1e-1Q;
  	for (int i=0; i<10; i++) {
    		float foobar_float = foo_float + bar_float;
    		fprintf(stdout, "%d %20.15e\n", 1+i, (double)(foobar_float - 1.0Q));
    		bar_float *= 0.1Q;
  	}
	printf("\n");
  	
	fprintf(stdout, "sizeof(double)=%d\n", sizeof(double));
	double foo_double = 1.0Q;
  	double bar_double = 1e-10Q;
  	for (int i=0; i<30; i++) {
    		double foobar_double = foo_double + bar_double;
    		fprintf(stdout, "%d %20.15e\n", 11+i, (double)(foobar_double - 1.0Q));
    		bar_double *= 0.1Q;
  	}
	printf("\n");

  	fprintf(stdout, "sizeof(long double)=%d\n", sizeof(long double));
	long double foo_longdouble = 1.0Q;
  	long double bar_longdouble = 1e-10Q;
  	for (int i=0; i<30; i++) {
    		long double foobar_longdouble = foo_longdouble + bar_longdouble;
    		fprintf(stdout, "%d %20.15e\n", 11+i, (double)(foobar_longdouble - 1.0Q));
    		bar_longdouble *= 0.1Q;
  	}
	printf("\n");

  	fprintf(stdout, "sizeof(__float128)=%d\n", sizeof(__float128));
	__float128 foo = 1.0Q;
  	__float128 bar = 1e-10Q;
  	for (int i=0; i<30; i++) {
    		__float128 foobar = foo + bar;
    		fprintf(stdout, "%d %20.15e\n", 11+i, (double)(foobar - 1.0Q));
    		bar *= 0.1Q;
  	}
	printf("\n");
}
