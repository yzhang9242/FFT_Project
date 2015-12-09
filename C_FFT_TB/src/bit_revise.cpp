#include <iostream>
#include "bit_revise.hpp"

using namespace std;

int bit_revise (int x, int w)
{
	int i = 0;
	int res = 0;
	for (i = 0; i < w/2; i++) {
		res += ((x % 4) << (w - 2 - 2 * i));
		x /= 4;
	}
	return res;
}
