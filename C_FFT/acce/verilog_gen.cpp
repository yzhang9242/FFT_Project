#include <iostream>
#include <fstream>

using namespace std;

int main()
{
	ofstream outfile;
	outfile.open("verilog_code");
	
	int state = 192;
	
	for (int i = 0; i < 4; i++) {
		for (int j = 0; j < 64; j++) {
			double phase = -(double)(j * i) / 256 * 360;
			int pls90 = 0;
			int min90 = 0;

			if (phase < -180)
				phase += 360;
			if (phase > 90) 
				pls90 = 1;
			if (phase < -90)
				min90 = 1;
			phase = (phase - pls90 * 90 + min90 * 90) * 256;

			outfile << state << " : begin pls90 <= " << pls90 << "; min90 <= " << min90 << "; phase <= " << (int)phase << "; end" << endl;
			
			state = (state + 1) % 256;
			//cout << phase << endl;
		}
	}
	outfile.close();

	return 0;
}

