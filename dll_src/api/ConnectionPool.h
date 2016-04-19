#ifndef SRC_CONNECTIONPOOL_H_
#define SRC_CONNECTIONPOOL_H_

#include "Connection.h"
#include "../api/mutex.h"
#include <vector>

class ConnectionPool
{
protected:
	std::string hostname;
	unsigned int port;
	std::string username;
	std::string password;
	std::string database;
	unsigned int maxWait;
	std::vector<Connection*> connections;
	Mutex pool_mutex;
	void init(std::string hostname, unsigned int port, std::string username, std::string password, std::string database, unsigned int maxWait);
public:
	virtual Connection* getConnection();
	void releaseConnection(Connection* conn);
};

#endif