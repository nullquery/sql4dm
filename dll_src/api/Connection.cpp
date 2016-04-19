#include "Connection.h"
#include <sstream>

ResultSet* Connection::exec(std::string query)
{
	std::vector<std::string> v;

	return exec(query, v);
}

ResultSet* Connection::exec(std::string query, std::vector<std::string> parameters)
{
	throw "Unimplemented operation!";
}

unsigned int Connection::execu(std::string query)
{
	std::vector<std::string> v;

	return execu(query, v);
}

unsigned int Connection::execu(std::string query, std::vector<std::string> parameters)
{
	throw "Unimplemented operation!";
}

bool Connection::isBusy()				{ return this->busy; }
void Connection::setBusy(bool busy)		{ this->busy = busy; }
