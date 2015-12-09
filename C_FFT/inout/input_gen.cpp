#include <iostream>
#include <fstream>
#include <cstdlib>

using namespace std;

int main()
{
	ofstream outfile;

	// Open output file
	outfile.open("./inout/fft.in");
		
	for (int i = 0; i < 256; i++) {
		int r = rand() % 154 - 90;
		outfile << r << endl;
	}

	outfile.close();

	return 0;
}
