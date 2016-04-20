#include "win32.h"
#include <chrono>
#include <string>
#include <memory.h>

long long lastUniqueID = 0;

extern "C" EXPORT char *getUniqueID(int n, char *v[])
{
	if (lastUniqueID == 0)
	{
		std::chrono::milliseconds ms				= std::chrono::duration_cast<std::chrono::milliseconds>(std::chrono::system_clock::now().time_since_epoch());
		lastUniqueID = ms.count();
	}

	long long id									= ++lastUniqueID;

	std::string str									= std::to_string(id);

	char* buf										= new char[str.size() + 1];
	memcpy(buf, str.c_str(), str.size());
	buf[str.size()]									= 0;
	
	return buf;
}
