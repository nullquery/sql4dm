#ifndef SRC_PGSQL_RESULTSET_H_
#define SRC_PGSQL_RESULTSET_H_

#include "../api/ResultSet.h"
#include <libpq-fe.h>

class PgsqlResultSet : ResultSet
{
public:
	void init(PGresult* res);
};

#endif