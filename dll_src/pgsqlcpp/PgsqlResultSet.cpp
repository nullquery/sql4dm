#include "PgsqlResultSet.h"
#include <algorithm>

void PgsqlResultSet::init(PGresult* res)
{
	int nFields													= PQnfields(res);

	for (int i = 0; i < nFields; i = i + 1)						{ this->columns.push_back(PQfname(res, i)); }

	int nTuples													= PQntuples(res);
	std::vector<std::string*>* v;
	char* value;

	for (int i = 0; i < nTuples; i = i + 1)
	{
		v														= new std::vector<std::string*>();

		for (int j = 0; j < nFields; j++)
		{
			if (PQgetisnull(res, i, j))							{ v->push_back(nullptr); }
			else
			{
				value											= PQgetvalue(res, i, j);

				v->push_back(new std::string(value, PQgetlength(res, i, j)));
			}
		}

		this->rows.push_back(v);
	}
}
