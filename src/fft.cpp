#include"fft.hpp"

void fft::fft_process(COMPLEX *X_out, COMPLEX x0, COMPLEX x1)
{
	X_out[0] = (COMPLEX) (x0 + x1 * W2_0);
	X_out[1] = (COMPLEX) (x0 - x1 * W2_0);
}

void fft::fft_process(COMPLEX *X_out, COMPLEX x0, COMPLEX x1, COMPLEX x2, COMPLEX x3)
{
	X_out[0] = (COMPLEX)(x0 + x2 * W4_0);
	X_out[1] = (COMPLEX)(x1 + x3 * W4_1);
	X_out[2] = (COMPLEX)(x0 - x2 * W4_0);
	X_out[3] = (COMPLEX)(x1 - x3 * W4_1);
}

void fft::fft_process(COMPLEX *X_out, COMPLEX x0, COMPLEX x1,
			COMPLEX x2, COMPLEX x3,
			COMPLEX x4, COMPLEX x5,
			COMPLEX x6, COMPLEX x7)
{
	X_out[0] = (COMPLEX)(x0 + x4 * W8_0);
	X_out[1] = (COMPLEX)(x1 + x5 * W8_1);
	X_out[2] = (COMPLEX)(x2 + x6 * W8_2);
	X_out[3] = (COMPLEX)(x3 + x7 * W8_3);
	X_out[4] = (COMPLEX)(x0 - x4 * W8_0);
	X_out[5] = (COMPLEX)(x1 - x5 * W8_1);
	X_out[6] = (COMPLEX)(x2 - x6 * W8_2);
	X_out[7] = (COMPLEX)(x3 - x7 * W8_3);
}
