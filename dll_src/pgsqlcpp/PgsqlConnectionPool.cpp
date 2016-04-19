#include "PgsqlConnectionPool.h"
#include "PgsqlConnection.h"
#include <fstream>

PgsqlConnectionPool::PgsqlConnectionPool(std::string hostname, unsigned int port, std::string username, std::string password, std::string database, unsigned int maxWait)
{
	this->init(hostname, port, username, password, database, maxWait);
}

PgsqlConnectionPool::~PgsqlConnectionPool()
{
	for (Connection* conn : this->connections)
	{
		conn->~Connection();
	}
}

Connection* PgsqlConnectionPool::getConnection()
{
	this->pool_mutex.lock();

	Connection* res					= nullptr;

	while (res == nullptr)
	{
		for (Connection* conn : this->connections)
		{
			if (!conn->isBusy())
			{
				res					= conn;

				break;
			}
		}

		if (res == nullptr)
		{
			if (this->connections.size() < this->maxWait)
			{
				Connection* conn	= new PgsqlConnection(std::string("postgres://" + username + ":" + password + "@" + hostname + ":" + std::to_string(port) + "/" + database));

				this->connections.push_back(conn);

				res					= conn;
			}
			else					{ SLEEP(1); }
		}
	}

	res->setBusy(true);

	this->pool_mutex.unlock();

	return res;
}
