#include "ConnectionPool.h"
#include <fstream>

void ConnectionPool::init(std::string hostname, unsigned int port, std::string username, std::string password, std::string database, unsigned int maxWait)
{
	this->hostname								= hostname;
	this->port									= port;
	this->username								= username;
	this->password								= password;
	this->database								= database;
	this->maxWait								= maxWait;
}

Connection* ConnectionPool::getConnection()
{
	throw "Unimplemented operation!";
}

void ConnectionPool::releaseConnection(Connection* conn)
{
	conn->setBusy(false);
}
