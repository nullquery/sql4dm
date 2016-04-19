#include "MysqlConnection.h"
#include "MysqlResultSet.h"
#include <sstream>

#include <iostream>
#include <fstream>
/*
std::ofstream myfile;
		myfile.open ("log.txt");
		myfile << "1\n";
		myfile.close();
*/

void replaceAll(std::string& str, const std::string& from, const std::string& to)
{
	if(!from.empty())
	{
		size_t start_pos							= 0;

		while((start_pos = str.find(from, start_pos)) != std::string::npos)
		{
			str.replace(start_pos, from.length(), to);
			start_pos								= start_pos + to.length();
		}
	}
}

MysqlConnection::MysqlConnection(std::string hostname, unsigned int port, std::string username, std::string password, std::string database)
{
	this->conn										= mysql_init(NULL);

	unsigned int connect_timeout					= 5;
	unsigned int read_timeout						= 60;
	unsigned int write_timeout						= 60;
	bool reconnect									= true;

	mysql_options(this->conn, mysql_option::MYSQL_OPT_CONNECT_TIMEOUT, &connect_timeout);
	mysql_options(this->conn, mysql_option::MYSQL_OPT_READ_TIMEOUT, &read_timeout);
	mysql_options(this->conn, mysql_option::MYSQL_OPT_WRITE_TIMEOUT, &write_timeout);
	mysql_options(this->conn, mysql_option::MYSQL_OPT_RECONNECT, &reconnect);

	mysql_real_connect(this->conn, hostname.c_str(), username.c_str(), password.c_str(), database.c_str(), port, NULL, CLIENT_REMEMBER_OPTIONS);
}

MysqlConnection::~MysqlConnection()
{
	mysql_close(this->conn);
}

ResultSet* MysqlConnection::exec(std::string query, std::vector<std::string> parameters)
{
	this->transaction_mutex.lock();

	if (mysql_ping(this->conn) != 0)
	{
		throw std::string("ERROR: No connection to server.");
	}

	MysqlResultSet* resultSet						= new MysqlResultSet();
	std::string error								= "";

	try
	{
		if (mysql_ping(this->conn) == 0)
		{
			mysql_autocommit(this->conn, 0);

			MYSQL_RES* res							= NULL;
			char* tmp;
			unsigned int length;

			if (!parameters.empty())
			{
				for (unsigned int i = 0; i < parameters.size(); i = i +1)
				{
					tmp								= new char[parameters[i].size() * 2];
					length							= mysql_real_escape_string(this->conn, tmp, parameters[i].c_str(), parameters[i].size());

					replaceAll(query, std::string("$1"), std::string("'" + std::string(tmp, length) + "'"));
				}
			}

			if (mysql_real_query(this->conn, query.c_str(), query.size()) == 0)
			{
				res								= mysql_store_result(this->conn);
			}

			if (res == NULL)
			{
				const char* err						= mysql_error(this->conn);

				error								= std::string(err);
			}
			else
			{
				resultSet->init(res);
			}

			mysql_free_result(res);

			mysql_commit(this->conn);
		}
	}
	catch (...)
	{
		try											{ mysql_rollback(this->conn); }
		catch (...)									{ /* no problem */ }
	}

	this->transaction_mutex.unlock();

	if (error == "")								{ return (ResultSet*) resultSet; }
	else											{ throw error; }
}

unsigned int MysqlConnection::execu(std::string query, std::vector<std::string> parameters)
{
	this->transaction_mutex.lock();

	if (mysql_ping(this->conn) != 0)
	{
		throw std::string("ERROR: No connection to server.");
	}

	unsigned int ret								= 0;
	std::string error								= "";

	try
	{
		if (mysql_ping(this->conn) == 0)
		{
			mysql_autocommit(this->conn, 0);

			char* tmp;
			
			if (parameters.empty())
			{
				mysql_query(this->conn, query.c_str());
			}
			else
			{
				MYSQL_STMT *stmt					= mysql_stmt_init(this->conn);

				mysql_stmt_prepare(stmt, query.c_str(), query.size());

				MYSQL_BIND* bind					= new MYSQL_BIND[parameters.size()];
//				memset(bind, 0, sizeof(bind));

				int i								= -1;

				for (std::string str : parameters)
				{
					i++;

					if (str == "_<_NULL_>_")
					{
						bind[i].buffer_type			= MYSQL_TYPE_NULL;
					}
					else
					{
						tmp							= new char[str.size() + 1];

						memcpy(tmp, str.c_str(), str.size());

						tmp[str.size()]				= 0;

						bind[i].buffer_type			= MYSQL_TYPE_STRING;
						bind[i].buffer				= tmp;
						bind[i].buffer_length		= strlen(tmp);
						bind[i].is_null				= 0;
						bind[i].length				= 0;
					}
				}

				mysql_stmt_bind_param(stmt, bind);
			}

			ret										= (unsigned int) mysql_affected_rows(this->conn);

			mysql_commit(this->conn);
		}
	}
	catch (...)
	{
		try											{ mysql_rollback(this->conn); }
		catch (...)									{ /* no problem */ }
	}

	this->transaction_mutex.unlock();

	if (error == "")								{ return ret; }
	else											{ throw error; }
}
