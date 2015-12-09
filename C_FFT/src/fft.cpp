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
	COMPLEX x1_img = x_in[1 * b] * (COMPLEX)1i;
	COMPLEX x3_img = x_in[3 * b] * (COMPLEX)1i;
	X_out[0] = (COMPLEX)(x_in[0] + x_in[b] + x_in[2 * b] + x_in[3 * b]);
	X_out[b] = (COMPLEX)(x_in[0] - x1_img - x_in[2 * b] + x3_img);
	X_out[2 * b] = (COMPLEX)(x_in[0] - x_in[b] + x_in[2 * b] - x_in[3 * b]);
	X_out[3 * b] = (COMPLEX)(x_in[0] + x1_img - x_in[2 * b] - x3_img);
}

void rotate(COMPLEX *x, int k, int n)
{
	*x = (*x * exp((COMPLEX)(-1i * 2 * PI * (double)k / n)));
}

void bit_reverse(COMPLEX *x, int w)
{
	COMPLEX *result = new COMPLEX[1 << w];
	int temp, i_s;

	for (int i = 0; i < 1 << w; i++)
	{
		temp = i;
		i_s = 0;
		for (int b = 0; b < w; b++)
		{
			i_s = i_s * 2 + temp % 2;
			temp /= 2;
		}
		result[i] = x[i_s];
	}
	
	for (int i = 0; i < 1 << w; i++)
		x[i] = result[i];

	delete[] result;
}
