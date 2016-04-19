#include "../dm_shared/dm.h"
#include "../mysqlcpp/MysqlConnectionPool.h"
#include "../mysqlcpp/MysqlConnection.h"

ConnectionPool* getPool(std::string hostname, unsigned int port, std::string username, std::string password, std::string database)
{
	std::string conninfo							= std::string("mysql://" + username + "@" + hostname + ":" + std::to_string(port) + "/" + database);
	if (!pools.count(conninfo))						{ pools[conninfo] = (ConnectionPool*) new MysqlConnectionPool(hostname, port, username, password, database, 8); }

	return pools[conninfo];
}

#include "../dm_shared/dm.cpp"