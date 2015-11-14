#include"fft.hpp"

// fft_r2 methods
void fft_r2::fft_r2_bf(COMPLEX *X_out, COMPLEX *x_in, int b)
{
	X_out[0] = (COMPLEX)(x_in[0] + x_in[b]);
	X_out[b] = (COMPLEX)(x_in[0] - x_in[b]);
}

// fft_r4 methods
void fft_r4::fft_r4_bf(COMPLEX *X_out, COMPLEX *x_in, int b)
{
	COMPLEX x1_img = x_in[1] * (COMPLEX)1i;
	COMPLEX x3_img = x_in[3] * (COMPLEX)1i;
	X_out[0] = (COMPLEX)(x_in[0] + x_in[1] + x_in[2] + x_in[3]);
	X_out[1] = (COMPLEX)(x_in[0] - x1_img - x_in[2] + x3_img);
	X_out[2] = (COMPLEX)(x_in[0] - x_in[1] + x_in[2] - x_in[3]);
	X_out[3] = (COMPLEX)(x_in[0] + x1_img - x_in[2] - x3_img);
}

void rotate(COMPLEX *x, int k, int n)
{
	*x = (*x * exp((COMPLEX)(-1i * 2 * PI * (double)k / n)));
}
