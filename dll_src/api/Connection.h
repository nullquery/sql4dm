#ifndef SRC_CONNECTION_H_
#define SRC_CONNECTION_H_

#include <string>
#include <string.h>
#include "mutex.h"
#include "ResultSet.h"

class Connection
{
protected:
	Mutex transaction_mutex;
	bool busy;
public:
	ResultSet* exec(std::string query);
	virtual ResultSet* exec(std::string query, std::vector<std::string> parameters);
	unsigned int execu(std::string query);
	virtual unsigned int execu(std::string query, std::vector<std::string> parameters);
	bool isBusy();
	void setBusy(bool busy);
};

#endif