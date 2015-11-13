#ifndef __FFT__

#include<cmath>
#include<complex>

#define PI std::acos(-1)
#define COMPLEX complex<double>

using namespace std;

class fft
{
	public:
	
	void fft_process(COMPLEX *X_out, COMPLEX x0, COMPLEX x1);
	void fft_process(COMPLEX *X_out, COMPLEX x0, COMPLEX x1, COMPLEX x2, COMPLEX x3);
	void fft_process(COMPLEX *X_out,
			COMPLEX x0, COMPLEX x1,
			COMPLEX x2, COMPLEX x3,
			COMPLEX x4, COMPLEX x5,
			COMPLEX x6, COMPLEX x7);

	fft()
	{
		W2_0 = 1;
		W4_0 = 1;
		W4_1 = -1i;
		W8_0 = 1;
		W8_1 = exp((COMPLEX)(-1i * PI / 4));
		W8_2 = exp((COMPLEX)(-1i * PI / 2));
		W8_3 = exp((COMPLEX)(-1i * PI * 3 / 4));
	}

	private:
	// 2-point FFT Twiddle Factors
	COMPLEX W2_0;
	
	// 4-point FFT Twiddle Factors
	COMPLEX W4_0;
	COMPLEX W4_1;
	
	// 8 point FFT Twiddle Factors
	COMPLEX W8_0;
	COMPLEX W8_1;
	COMPLEX W8_2;
	COMPLEX W8_3;
};

#endif
