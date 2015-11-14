#include<iostream>
#include<fstream>
#include"fft.hpp"

using namespace std;

int main()
{
	ifstream infile;

	fft_r2 fft_2;
	COMPLEX *x_in = new COMPLEX[8];
	COMPLEX *x_out = new COMPLEX[8];

	// Read input from file
	infile.open("./inout/fft.in");
	for (int i = 0; i < 8; i++)
	{
		double temp;
		infile >> temp;
		x_in[i] = (COMPLEX)(temp);
	}
	infile.close();

	// Stage 1
	COMPLEX *x_1 = new COMPLEX[8];
	fft_2.fft_r2_bf(x_1, x_in, 4);
	fft_2.fft_r2_bf(&x_1[1], &x_in[1], 4);
	fft_2.fft_r2_bf(&x_1[2], &x_in[2], 4);
	fft_2.fft_r2_bf(&x_1[3], &x_in[3], 4);

	rotate(&x_1[4], 0, 8);
	rotate(&x_1[5], 1, 8);
	rotate(&x_1[6], 2, 8);
	rotate(&x_1[7], 3, 8);
	// Output
	for (int i = 0; i < 8; i++)
	{
		cout << x_1[i] << endl;
	}

	return 0;
}
