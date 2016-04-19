#include "../dm_shared/dm.h"
#include "../pgsqlcpp/PgsqlConnectionPool.h"
#include "../pgsqlcpp/PgsqlConnection.h"

ConnectionPool* getPool(std::string hostname, unsigned int port, std::string username, std::string password, std::string database)
{
	std::string conninfo							= std::string("postgresql://" + username + "@" + hostname + ":" + std::to_string(port) + "/" + database);
	if (!pools.count(conninfo))						{ pools[conninfo] = (ConnectionPool*) new PgsqlConnectionPool(hostname, port, username, password, database, 8); }

	return pools[conninfo];
}

#include "../dm_shared/dm.cpp"