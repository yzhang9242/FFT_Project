#include <iostream>
#include <fstream>
#include <cstdlib>
#include <ctime>

using namespace std;

int main()
{
	ofstream outfile;
	ofstream verilog_in;;

	// Open output file
	outfile.open("./inout/fft.in");
	verilog_in.open("../vsim_FFT/fft.in");

	srand(time(0));		
	for (int i = 0; i < 256; i++) {
		int r = rand() % 123 - 67;
		outfile << r << endl;
		verilog_in << r << endl;
	}

	outfile.close();
	verilog_in.close();

	return 0;
}
