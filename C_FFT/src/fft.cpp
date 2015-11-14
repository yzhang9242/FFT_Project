#include"fft.hpp"

// fft_r2 methods
void fft_r4::fft_r4_bf(COMPLEX *X_out, COMPLEX *x_in, int b)
{
	X_out[0] = (COMPLEX)(x_in[0] + x_in[b]);
	X_out[b] = (COMPLEX)(x_in[0] - x_in[b]);
}

// fft_r4 methods
void fft_r4::fft_r4_bf(COMPLEX *X_out, COMPLEX *x_in)
{
	X_out[0] = (COMPLEX)(x_in[0] + x_in[1] + x_in[2] + x_in[3]);
	X_out[1] = (COMPLEX)(x_in[0] - 1i * x_in[1] - x_in[2] + 1i * x_in[3]);
	X_out[2] = (COMPLEX)(x_in[0] - x_in[1] + x_in[2] - x_in[3]);
	X_out[3] = (COMPLEX)(x_in[0] + 1i * x_in[1] - x_in[2] - 1i * x_in[3]);
}
