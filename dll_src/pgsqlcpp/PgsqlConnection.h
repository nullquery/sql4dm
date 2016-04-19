#ifndef SRC_PGSQLCONNECTION_H_
#define SRC_PGSQLCONNECTION_H_

#include "../api/Connection.h"
#include <libpq-fe.h>

class PgsqlConnection : public Connection
{
private:
	PGconn* conn;
public:
	PgsqlConnection(std::string conninfo);
	~PgsqlConnection();
	ResultSet* exec(std::string query, std::vector<std::string> parameters);
	unsigned int execu(std::string query, std::vector<std::string> parameters);
};

#endif