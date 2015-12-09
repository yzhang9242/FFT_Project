#include<iostream>
#include<fstream>
#include"fft.hpp"

using namespace std;

int main()
{
	ifstream infile;

	fft_r4 fft_4;

	COMPLEX *x_in = new COMPLEX[256];
	COMPLEX *x_4 = new COMPLEX[256];
	COMPLEX *x_16 = new COMPLEX[256];
	COMPLEX *x_64 = new COMPLEX[256];
	COMPLEX *x_256 = new COMPLEX[256];

	// Read input from file
	infile.open("./inout/fft.in");
	for (int i = 0; i < 256; i++)
	{
		double temp;
		infile >> temp;
		x_in[i] = (COMPLEX)(temp);
	}
	infile.close();
	
	
	// Stage 256 point
	for (int i = 0; i < 64; i++)
		fft_4.fft_r4_bf(&x_256[i], &x_in[i], 64);

	for (int i = 64, j = 0; i < 128; i++, j++)
		rotate(&x_256[i], j, 256);
	for (int i = 128, j = 0; i < 192; i++, j++)
		rotate(&x_256[i], 2 * j, 256);
	for (int i = 192, j = 0; i < 256; i++, j++)
		rotate(&x_256[i], j * 3, 256);

	// Stage 64 point
	for (int i = 0; i < 256; i += 64) {

		for (int j = 0; j < 16; j++)
			fft_4.fft_r4_bf(&x_64[i + j], &x_256[i + j], 16);
	
		for (int j = 16, k = 0; j < 32; j++, k++)
			rotate(&x_64[i + j], k, 64);
		for (int j = 32, k = 0; j < 48; j++, k++)
			rotate(&x_64[i + j], 2 * k, 64);
		for (int j = 48, k = 0; j < 64; j++, k++)
			rotate(&x_64[i + j], k * 3, 64);
	}

	// 16 point stage
	for (int i = 0; i < 256; i += 16) {

		for (int j = 0; j < 4; j++)
			fft_4.fft_r4_bf(&x_16[i + j], &x_64[i + j], 4);
	
		for (int j = 4, k = 0; j < 8; j++, k++)
			rotate(&x_16[i + j], k, 16);
		for (int j = 8, k = 0; j < 12; j++, k++)
			rotate(&x_16[i + j], 2 * k, 16);
		for (int j = 12, k = 0; j < 16; j++, k++)
			rotate(&x_16[i + j], k * 3, 16);
	}

	// 4 point stage
	for (int i = 0; i < 256; i += 4) {
		fft_4.fft_r4_bf(&x_4[i], &x_16[i], 1);
	}
	
	//bit_reverse(x_4, 8);

	for (int i = 0; i < 256; i++)
		cout << 1.64 * 1.64 * 1.64 * real(x_4[i]) << endl;
	return 0;
}
