#include<iostream>
#include<fstream>
#include"fft.hpp"

using namespace std;

int main()
{
	ifstream infile;

	fft fft_2;
	double *x_in = new double[8];
	COMPLEX *x_out = new COMPLEX[8];

	// Read input from file
	infile.open("./inout/fft.in");
	for (int i = 0; i < 8; i ++)
	{
		int b = i;
		int shift = (b % 2) * 4;
		b /= 2;
		shift += (b % 2) * 2;
		b /= 2;
		shift += b % 2;
		infile >> x_in[shift];
	}
	infile.close();

	// 2-point FFT
	COMPLEX *x1 = new COMPLEX[8];
	fft_2.fft_process(&x1[0], x_in[0], x_in[1]);
	fft_2.fft_process(&x1[2], x_in[2], x_in[3]);
	fft_2.fft_process(&x1[4], x_in[4], x_in[5]);
	fft_2.fft_process(&x1[6], x_in[6], x_in[7]);

	// 4-point FFT
	COMPLEX *x2 = new COMPLEX[8];
	fft_2.fft_process(&x2[0], x1[0], x1[1], x1[2], x1[3]);
	fft_2.fft_process(&x2[4], x1[4], x1[5], x1[6], x1[7]);

	// 8-point FFT
	fft_2.fft_process(&x_out[0], x2[0], x2[1], x2[2], x2[3], 
			x2[4], x2[5], x2[6], x2[7]);
	
	// Output
	for (int i = 0; i < 8; i++)
	{
		cout << x_out[i] << endl;
	}

	return 0;
}
