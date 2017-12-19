#include<iostream>  
#include<string>  
#include <limits>  
using namespace std;  
  
int main(){  
	cout << "type: \n\t\t" << "************size**************"<< endl;  

    	cout << "  bool: " << endl;
	cout << "	# of Bytes = " << sizeof(bool) << endl;  
    	cout << "	Max Value =" << (numeric_limits<bool>::max)() << endl;  
    	cout << "	Min Value =" << (numeric_limits<bool>::min)() << endl;  

    	cout << "char: " << endl;
	cout << "	# of Bytes = " << sizeof(char) << endl;  
    	cout << "	Max Value = " << (numeric_limits<char>::max)() << endl;  
    	cout << "	Min Value = " << (numeric_limits<char>::min)() << endl;  

    	cout << "signed char: " << endl;
	cout << "	# of Bytes = " << sizeof(signed char) << endl;  
    	cout << "	Max Value = " << (numeric_limits<signed char>::max)() << endl;  
    	cout << "	Min Value = " << (numeric_limits<signed char>::min)() << endl;  

    	cout << "unsigned char: " << endl;
	cout << "	# of Bytes = " << sizeof(unsigned char) << endl;  
    	cout << "	Max Value = " << (numeric_limits<unsigned char>::max)() << endl;  
    	cout << "	Min Value = " << (numeric_limits<unsigned char>::min)() << endl;  

    	cout << "wchar_t: \n\t" << endl;
	cout << "	# of Bytes = " << sizeof(wchar_t) << endl;  
    	cout << "	Max Value = " << (numeric_limits<wchar_t>::max)() << endl;  
    	cout << "	Min Value = " << (numeric_limits<wchar_t>::min)() << endl;  

    	cout << "short: \n\t\t" << endl;
	cout << "	# of Bytes = " << sizeof(short) << endl;  
    	cout << "	Max Value = " << (numeric_limits<short>::max)() << endl;  
    	cout << "	Min Value = " << (numeric_limits<short>::min)() << endl;  


    	cout << "int: \n\t\t" << endl;
	cout << "	# of Bytes = " << sizeof(int) << endl;  
    	cout << "	Max Value = " << (numeric_limits<int>::max)() << endl;  
    	cout << "	Min Value = " << (numeric_limits<int>::min)() << endl;  

    	cout << "unsigned: \n\t" << endl;
	cout << " 	# of Bytes = " << sizeof(unsigned) << endl;  
    	cout << "	Max Value = " << (numeric_limits<unsigned>::max)() << endl;  
    	cout << "	Min Value = " << (numeric_limits<unsigned>::min)() << endl;  

    	cout << "long: \n\t\t" << endl;
	cout << "	# of Bytes = " << sizeof(long) << endl;  
    	cout << "	Max Value = " << (numeric_limits<long>::max)() << endl;  
    	cout << "	Min Value = " << (numeric_limits<long>::min)() << endl;  

    	cout << "unsigned long: \n\t" << endl;
	cout << " 	# of Bytes = " << sizeof(unsigned long) << endl;  
    	cout << "	Max Value = " << (numeric_limits<unsigned long>::max)() << endl;  
    	cout << "	Min Value = " << (numeric_limits<unsigned long>::min)() << endl;  

    	cout << "long long: \n\t\t" << endl;
	cout << "	# of Bytes = " << sizeof(long long) << endl;  
    	cout << "	Max Value = " << (numeric_limits<long long>::max)() << endl;  
    	cout << "	Min Value = " << (numeric_limits<long long>::min)() << endl;  

    	cout << "float: \n\t\t" << endl;
	cout << "	# of Bytes = " << sizeof(float) << endl;  
    	cout << "	Max Value = " << (numeric_limits<float>::max)() << endl;  
    	cout << "	Min Value = " << (numeric_limits<float>::min)() << endl; 
 
    	cout << "double: \n\t" << endl;
	cout << " 	# of Bytes = " << sizeof(double) << endl;  
    	cout << "	Max Value = " << (numeric_limits<double>::max)() << endl;  
    	cout << "	Min Value = " << (numeric_limits<double>::min)() << endl;  

    	cout << "long double: \n\t" << endl;
	cout << "	# of Bytes = " << sizeof(long double) << endl;  
	cout << "	Max Value = " << (numeric_limits<long double>::max)() << endl;  
    	cout << "	Min Value = " << (numeric_limits<long double>::min)() << endl;  

    	cout << "__float128: \n\t\t" << endl;
	cout << "	# of Bytes = " << sizeof(__float128) << endl;  
//    	cout << "	Max Value = " << (numeric_limits< __float128 >::max)() << endl;  
//    	cout << "	Min Value = " << (numeric_limits<__float128>::min)() << endl; 

    	cout << "size_t: \n\t" << endl;
	cout <<"	# of Bytes = " << sizeof(size_t) << endl;  
    	cout << "	Max Value = " << (numeric_limits<size_t>::max)() << endl;  
    	cout << "	Min Value = " << (numeric_limits<size_t>::min)() << endl;  

    	cout << "string: \n\t" << endl;
	cout << "	# of Bytes = " << sizeof(string) << endl;  
    	cout << "	Max Value = " << (numeric_limits<string>::max)() << endl; 
	cout << "	Min Value = " << (numeric_limits<string>::min)() << endl;  
    	cout << "type: \t\t" << "************size**************"<< endl;  

    	return 0;  
}
