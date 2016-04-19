#include "MysqlConnectionPool.h"
#include "MysqlConnection.h"
#include <fstream>

MysqlConnectionPool::MysqlConnectionPool(std::string hostname, unsigned int port, std::string username, std::string password, std::string database, unsigned int maxWait)
{
	this->init(hostname, port, username, password, database, maxWait);
}

MysqlConnectionPool::~MysqlConnectionPool()
{
	for (Connection* conn : this->connections)
	{
		conn->~Connection();
	}
}

#include <iostream>
#include <fstream>

Connection* MysqlConnectionPool::getConnection()
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
				Connection* conn	= new MysqlConnection(this->hostname, this->port, this->username, this->password, this->database);

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
