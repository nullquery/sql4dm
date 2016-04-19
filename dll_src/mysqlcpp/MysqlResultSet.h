#ifndef SRC_MYSQL_RESULTSET_H_
#define SRC_MYSQL_RESULTSET_H_

#include "../api/ResultSet.h"
#include <mysql.h>

class MysqlResultSet : ResultSet
{
public:
	void init(MYSQL_RES* res);
	void init(MYSQL_STMT* stmt, MYSQL_BIND* bind, unsigned int fieldCount, MYSQL_RES* res);
};

#endif