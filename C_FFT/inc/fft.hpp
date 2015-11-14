#ifndef __FFT__

#include<cmath>
#include<complex>

#define PI std::acos(-1)
#define COMPLEX complex<double>

using namespace std;

class fft_r2
{
	public:
	void fft_r2_bf(COMPLEX *X_out, COMPLEX *x_in, int b);
};

class fft_r4
{
	public:
	void fft_r4_bf(COMPLEX *X_out, COMPLEX *x_in, int b);
};

void rotate(COMPLEX *x, int k, int n);
#endif
