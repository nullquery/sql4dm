#ifndef SRC_MYSQLCONNECTION_H_
#define SRC_MYSQLCONNECTION_H_

#include "../api/Connection.h"
#include <mysql.h>

class MysqlConnection : public Connection
{
private:
	MYSQL* conn;
public:
	MysqlConnection(std::string hostname, unsigned int port, std::string username, std::string password, std::string database);
	~MysqlConnection();
	ResultSet* exec(std::string query, std::vector<std::string> parameters);
	unsigned int execu(std::string query, std::vector<std::string> parameters);
};

#endif