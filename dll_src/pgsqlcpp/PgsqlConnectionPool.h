#ifndef SRC_PGSQL_CONNECTIONPOOL_H_
#define SRC_PGSQL_CONNECTIONPOOL_H_

#include "../api/ConnectionPool.h"

class PgsqlConnectionPool : ConnectionPool
{
public:
	PgsqlConnectionPool(std::string hostname, unsigned int port, std::string username, std::string password, std::string database, unsigned int maxWait);
	~PgsqlConnectionPool();
	Connection* getConnection();
	void releaseConnection(Connection* conn);
};

#endif