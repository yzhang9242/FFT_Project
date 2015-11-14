#include<iostream>
#include<fstream>
#include"fft.hpp"

using namespace std;

int main()
{
	ifstream infile;

	fft_r2 fft_2;
	COMPLEX *x_in = new COMPLEX[8];
	COMPLEX *X_out = new COMPLEX[8];

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

	// Stage 2
	COMPLEX *x_2 = new COMPLEX[8];
	fft_2.fft_r2_bf(x_2, x_1, 2);
	fft_2.fft_r2_bf(&x_2[1], &x_1[1], 2);
	fft_2.fft_r2_bf(&x_2[4], &x_1[4], 2);
	fft_2.fft_r2_bf(&x_2[5], &x_1[5], 2);

	rotate(&x_2[2], 0, 4);
	rotate(&x_2[3], 1, 4);
	rotate(&x_2[6], 0, 4);
	rotate(&x_2[7], 1, 4);

	// Stage 3
	fft_2.fft_r2_bf(X_out, x_2, 1);
	fft_2.fft_r2_bf(&X_out[2], &x_2[2], 1);
	fft_2.fft_r2_bf(&X_out[4], &x_2[4], 1);
	fft_2.fft_r2_bf(&X_out[6], &x_2[6], 1);

	rotate(&X_out[0], 0, 2);
	rotate(&X_out[2], 0, 2);
	rotate(&X_out[4], 0, 2);
	rotate(&X_out[6], 0, 2);

	// Output
	for (int i = 0; i < 8; i++)
	{
		cout << X_out[i] << endl;
	}

	return 0;
}
