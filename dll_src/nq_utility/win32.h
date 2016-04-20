#ifndef SRC_WIN32_H_
#define SRC_WIN32_H_

#ifdef _WIN32
	#define WIN32_LEAN_AND_MEAN
	#define _WIN32_WINNT 0x501
	#include <windows.h>
	#include <tchar.h>

	#define SLEEP(x) Sleep(x)

	#define NOMINMAX
	#define EXPORT __declspec(dllexport)
	#include <stdlib.h>

#else
	#include <unistd.h>

	#define SLEEP(x) sleep(x)

	#define EXPORT
	#include <string>
#endif

#endif