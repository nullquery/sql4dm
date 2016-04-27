#ifndef SRC_WIN32_CPP_
#define SRC_WIN32_CPP_

#include "win32.h"
#include <string>

#ifdef _WIN32
	void intToChar(int a, char* b, int size)
	{
		_itoa_s(a, b, size, 10);
	}

	void doubleToChar(double a, char* b, int size)
	{
		std::string str = std::to_string(a);
		
		strcpy_s(b, size, str.c_str());
	}
#else
	void intToChar(int a, char* b, int size)
	{
		snprintf(b, size, "%d", a);
	}

	void doubleToChar(double a, char* b, int size)
	{
		snprintf(b, size, "%f", a);
	}
#endif

#endif