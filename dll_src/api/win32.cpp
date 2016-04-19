#ifndef SRC_WIN32_CPP_
#define SRC_WIN32_CPP_

#include "win32.h"

#ifdef _WIN32
	void intToChar(int a, char* b, int size)
	{
		_itoa_s(a, b, size, 10);
	}
#else
	void intToChar(int a, char* b, int size)
	{
		snprintf(b, size, "%d", a);
	}
#endif

#endif