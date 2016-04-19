#ifndef SRC_MYSQL_CONNECTIONPOOL_H_
#define SRC_MYSQL_CONNECTIONPOOL_H_

#include "../api/ConnectionPool.h"

class MysqlConnectionPool : ConnectionPool
{
public:
	MysqlConnectionPool(std::string hostname, unsigned int port, std::string username, std::string password, std::string database, unsigned int maxWait);
	~MysqlConnectionPool();
	Connection* getConnection();
	void releaseConnection(Connection* conn);
};

#endif