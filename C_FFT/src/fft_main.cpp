#include<iostream>
#include<fstream>
#include"fft.hpp"

using namespace std;

int main()
{
	ifstream infile;

	fft_r2 fft_2;
	double *x_in = new double[8];
	COMPLEX *x_out = new COMPLEX[8];

	// Read input from file
	infile.open("./inout/fft.in");
	for (int i = 0; i < 8; i++)
	{
		infile >> x_in[i];
	}
	infile.close();

	// Stage 1
	COMPLEX *x_1 = new COMPLE[8];
	fft_2.fft_r2_bf(x_1, x_in, 1);
	fft_2.fft_r2_bf(x1[2], x_in[2], 1);
	fft_2.fft_r2_bf(x1[4], x_in[4], 1);
	fft_2.fft_r2_bf(x1[6], x_in[6], 1);

	
	
	//
	// Output
	for (int i = 0; i < 8; i++)
	{
		cout << x_out[i] << endl;
	}

	return 0;
}
