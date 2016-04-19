#ifndef SRC_DM_H_
#define SRC_DM_H_

#include <string>
#include <string.h>
#include <map>
#include "../api/ConnectionPool.h"
#include "../api/Connection.h"
#include "../api/DO.h"
#include <stdio.h>
#include <sstream>

std::map<std::string, ConnectionPool*> pools;
std::map<unsigned int, ResultSet*> results;

ConnectionPool* getPool(std::string hostname, unsigned int port, std::string username, std::string password, std::string database);

#endif