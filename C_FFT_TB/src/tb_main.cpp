#include <iostream>

#include "bit_revise.hpp"

using namespace std;

int main()
{
	for (int i = 0; i < 16; i++) {
		cout << bit_revise(i, 4) << endl;
	}
	return 0;
}
