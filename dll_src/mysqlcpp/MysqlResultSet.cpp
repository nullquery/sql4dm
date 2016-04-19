#include "MysqlResultSet.h"
#include <algorithm>

void MysqlResultSet::init(MYSQL_RES* res)
{
	MYSQL_FIELD* field;

	while ((field = mysql_fetch_field(res)) != NULL)			{ this->columns.push_back(field->name); }

	unsigned long long nTuples									= mysql_num_rows(res);
	std::vector<std::string*>* v;
	char* value;

	MYSQL_ROW row;
	unsigned long* lengths;

	while ((row = mysql_fetch_row(res)) != NULL)
	{
		lengths													= mysql_fetch_lengths(res);
		v														= new std::vector<std::string*>();

		for (unsigned int j = 0; j < this->columns.size(); j++)
		{
			if (row[j] == NULL)									{ v->push_back(nullptr); }
			else
			{
				value											= row[j];

				v->push_back(new std::string(value, lengths[j]));
			}
		}

		this->rows.push_back(v);
	}
}

void MysqlResultSet::init(MYSQL_STMT* stmt, MYSQL_BIND* bind, unsigned int fieldCount, MYSQL_RES* res)
{
	MYSQL_FIELD* field;

	while ((field = mysql_fetch_field(res)) != NULL)			{ this->columns.push_back(field->name); }

	std::vector<std::string*>* v;
	char* value;

	while (mysql_stmt_fetch(stmt) == 0)
	{
		v														= new std::vector<std::string*>();

		for (unsigned int i = 0; i < fieldCount; i = i + 1)
		{
			if (bind[i].is_null)								{ v->push_back(nullptr); }
			else
			{
				value											= (char*) bind[i].buffer;

				v->push_back(new std::string(value, bind[i].buffer_length));
			}
		}

		this->rows.push_back(v);
	}
}