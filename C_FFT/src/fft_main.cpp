#include<iostream>
#include<fstream>
#include"fft.hpp"

using namespace std;

int main()
{
	ifstream infile;

	fft_r4 fft_4;

	COMPLEX *x_in = new COMPLEX[64];
	COMPLEX *x_4 = new COMPLEX[64];
	COMPLEX *x_16 = new COMPLEX[64];
	COMPLEX *x_64 = new COMPLEX[64];
	COMPLEX *x_256 = new COMPLEX[64];

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

	

	// Stage 64 point stage
	for (int i = 0; i < 16; i++) 
		fft_4.fft_r4_bf(&x_64[i], &x_in[i], 16);

	
	for (int i = 16, j = 0; i < 32; i++, j++)
		rotate(&x_64[i], j, 64);
	for (int i = 32, j = 0; i < 48; i++, j++)
		rotate(&x_64[i], 2 * j, 64);
	for (int i = 48, j = 0; i < 64; i++, j++)
		rotate(&x_64[i], j * 3, 64);

	// 16 point stage
	for (int i = 0; i < 64; i += 16) {
		fft_4.fft_r4_bf(&x_16[i], &x_64[i], 4);
		fft_4.fft_r4_bf(&x_16[i + 1], &x_64[i + 1], 4);
		fft_4.fft_r4_bf(&x_16[i + 2], &x_64[i + 2], 4);
		fft_4.fft_r4_bf(&x_16[i + 3], &x_64[i + 3], 4);
	
	}
	for (int i = 0; i < 64; i += 16) {
		for (int j = 4, k = 0; j < 8; j++, k++) {
			rotate(&x_16[i + j], k, 16);
			//cout << i + j << ' ' << k << endl;
		}
		for (int j = 8, k = 0; j < 12; j++, k++) {
			rotate(&x_16[i + j], k * 2, 16);
			//cout << i + j << ' ' << k * 2 << endl;
		}
		for (int j = 12, k = 0; j < 16; j++, k++) {
			rotate(&x_16[i + j], k * 3, 16);
			//cout << i + j << ' ' << k * 3 << endl;
		}
	}

	// 4 point stage
	for (int i = 0; i < 64; i += 4) {
		fft_4.fft_r4_bf(&x_4[i], &x_16[i], 1);
		//fft_4.fft_r4_bf(&x_4[i + 1], &x_16[i + 1], 1);
		//fft_4.fft_r4_bf(&x_4[i + 2], &x_16[i + 2], 1);
		//fft_4.fft_r4_bf(&x_4[i + 3], &x_16[i + 3], 1);
	}

	// Print output
	for (int i = 0; i < 64; i++) {
		cout << x_4[i] << " --> " << (COMPLEX)(1.64 * 1.64 * x_4[i]) << endl;
	}
	return 0;
}
