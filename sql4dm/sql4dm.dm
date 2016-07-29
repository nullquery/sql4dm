/*
    sql4dm: Abstraction layer for database operation libraries
    Copyright (C) 2016  NullQuery (http://www.byond.com/members/NullQuery)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#define LIBSQL4DM_TRACKER_URL "http://www.byond.com/forum/?forum=148847"

/sql4dm/DatabaseConnection/var/hostname
/sql4dm/DatabaseConnection/var/port
/sql4dm/DatabaseConnection/var/username
/sql4dm/DatabaseConnection/var/password
/sql4dm/DatabaseConnection/var/database
/sql4dm/DatabaseConnection/var/dbtype

/sql4dm/DatabaseConnection/New(hostname, port, username, password, database)
	src.hostname = hostname
	src.port     = port
	src.username = username
	src.password = password
	src.database = database

	return ..();

/sql4dm/DatabaseConnection/Del()
	src.Dispose()

	return ..()

/sql4dm/DatabaseConnection/proc/Dispose()
/sql4dm/DatabaseConnection/proc/Execute(query, ...)
/sql4dm/DatabaseConnection/proc/Query(query, ...)

/sql4dm/ResultSet/var/id;

/sql4dm/ResultSet/New(id)
	src.id = id

	return ..()

/sql4dm/ResultSet/Del()
	src.Dispose()

	return ..()

/sql4dm/ResultSet/proc/CallProcResult(function, ...)
/sql4dm/ResultSet/proc/CallProcGet(function, ...)

/sql4dm/ResultSet/proc/Dispose()
	CallProcResult("dispose")

/sql4dm/ResultSet/proc/Next()                  { return CallProcResult("next"); }
/sql4dm/ResultSet/proc/Previous()              { return CallProcResult("previous"); }
/sql4dm/ResultSet/proc/IsBeforeFirst()         { return CallProcResult("isBeforeFirst"); }
/sql4dm/ResultSet/proc/IsAfterLast()           { return CallProcResult("isAfterLast"); }
/sql4dm/ResultSet/proc/IsFirst()               { return CallProcResult("isFirst"); }
/sql4dm/ResultSet/proc/IsLast()                { return CallProcResult("isLast"); }
/sql4dm/ResultSet/proc/First()                 { return CallProcResult("first"); }
/sql4dm/ResultSet/proc/Last()                  { return CallProcResult("last"); }
/sql4dm/ResultSet/proc/GetColumnNumber(column) { return CallProcResult("getNumber", column); }

/sql4dm/ResultSet/proc/GetString(column)
{
	var/res                                    = CallProcGet("get", "[src.id]", isnum(column) ? "i" : "c", "[column]");

	if      (res == "_<SQL4DM_ERROR>_-1")      { throw EXCEPTION("An unknown error occurred. Please leave a detailed bug report at '[LIBSQL4DM_TRACKER_URL]'. (Error code: 0x1)"); }
	else if (res == "_<SQL4DM_ERROR>_-2")      { throw EXCEPTION("Invalid number of arguments."); }
	else if (res == "_<SQL4DM_ERROR>_-3")      { throw EXCEPTION("ResultSet not found (id = [src.id])."); }
	else if (res == "_<SQL4DM_ERROR>_-4")      { throw EXCEPTION("Invalid column name."); }
	else if (res == "_<SQL4DM_ERROR>_-5")      { throw EXCEPTION("Invalid column position."); }
	else if (res == "_<SQL4DM_NULL>_")         { return null; }
	else                                       { return res; }
}

/sql4dm/ResultSet/proc/GetNumber(column, defaultValue = 0)
{
	try
	{
		var/res                                = GetString(column);
		var/n                                  = text2num(res);

		if (res != -1.#INF && res != 1.#INF)   { return n; }
		else                                   { return defaultValue; }
	}
	catch (var/ex)                             { throw(ex); }
}

#undef LIBSQL4DM_TRACKER_URL
