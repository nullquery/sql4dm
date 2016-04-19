/*
    pgsql4dm: PostgreSQL database operations for BYOND worlds
    Copyright (C) 2016  NullQuery (http://www.byond.com/members/NullQuery)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

// Override these to provide alternative locations to the shared library.

#ifndef LIBPGSQL4DM_DLL_WIN32
#define LIBPGSQL4DM_DLL_WIN32 "./libpgsql4dm.dll"
#endif

#ifndef LIBPGSQL4DM_DLL_UNIX
#define LIBPGSQL4DM_DLL_UNIX "./libpgsql4dm.so"
#endif

#define LIBPGSQL4DM_TRACKER_URL "http://www.byond.com/forum/?forum=146927"

/sql4dm/PgsqlDatabaseConnection/parent_type = /sql4dm/DatabaseConnection

/sql4dm/PgsqlDatabaseConnection/proc/CallProc(function, ...)
	var/list/L										= args.Copy(2)

	return call(world.system_type == MS_WINDOWS ? LIBPGSQL4DM_DLL_WIN32 : LIBPGSQL4DM_DLL_UNIX, function)(arglist(L))

/sql4dm/PgsqlDatabaseConnection/Dispose()
	src.CallProc("dispose", "[hostname]", "[port]", "[username]", "[password]", "[database]")

/sql4dm/PgsqlDatabaseConnection/Execute(query, ...)
	var/list/L                             = new/list()
	L.Add("execu")
	L.Add("[hostname]")
	L.Add("[port]")
	L.Add("[username]")
	L.Add("[password]")
	L.Add("[database]")

	var/first                              = TRUE
	for (var/argument in args)             { L.Add("[!first && argument == null ? "_<_NULL_>_" : argument]"); first = FALSE }

	var/res                                = src.CallProc(arglist(L))

	if      (res == "-1")                  throw EXCEPTION("An unknown error occurred. Please leave a detailed bug report at '[LIBPGSQL4DM_TRACKER_URL]'. (Error code: 0x1)")
	else if (res == "-2")                  throw EXCEPTION("Invalid number of arguments.")
	else if (res == "-3")                  throw EXCEPTION("An unknown error occurred. Please leave a detailed bug report at '[LIBPGSQL4DM_TRACKER_URL]'. (Error code: 0x2)")
	else
		if (findtext(res, "_<SQLERROR>_")) throw EXCEPTION(copytext(res, 13))
		else                               return text2num(res)

/sql4dm/PgsqlDatabaseConnection/Query(query, ...)
	var/list/L                             = new/list()
	L.Add("exec")
	L.Add("[hostname]")
	L.Add("[port]")
	L.Add("[username]");
	L.Add("[password]");
	L.Add("[database]");
	var/first                              = TRUE
	for (var/argument in args)             { L.Add("[!first && argument == null ? "_<_NULL_>_" : argument]"); first = FALSE }

	var/res                                = src.CallProc(arglist(L))

	if      (res == "-1")                  throw EXCEPTION("An unknown error occurred. Please leave a detailed bug report at '[LIBPGSQL4DM_TRACKER_URL]'. (Error code: 1x1)")
	else if (res == "-2")                  throw EXCEPTION("Invalid number of arguments.")
	else if (res == "-3")                  throw EXCEPTION("An unknown error occurred. Please leave a detailed bug report at '[LIBPGSQL4DM_TRACKER_URL]'. (Error code: 1x2)")
	else
		if (findtext(res, "_<SQLERROR>_")) throw EXCEPTION(copytext(res, 13))
		else                               return new/sql4dm/PgsqlResultSet(res)

/sql4dm/PgsqlResultSet/parent_type = /sql4dm/ResultSet

/sql4dm/PgsqlResultSet/CallProcResult(function, ...)
	var/list/L = new/list()
	L.Add("result")
	L.Add("[src.id]")
	for (var/argument in args)             { L.Add("[argument]") }

	var/res                                = src.CallProcGet(arglist(L))

	if      (res == "-1")                  throw EXCEPTION("An unknown error occurred. Please leave a detailed bug report at '[LIBPGSQL4DM_TRACKER_URL]'. (Error code: 2x1)")
	else if (res == "-2")                  throw EXCEPTION("Invalid number of arguments.")
	else if (res == "-3")                  throw EXCEPTION("ResultSet not found. (id = [src.id])")
	else if (res == "-4")                  throw EXCEPTION("Invalid function.")
	else if (res == "-5")                  throw EXCEPTION("Invalid column name.")
	else if (res == "-6")                  throw EXCEPTION("Invalid position.")
	else                                   return text2num(res)

/sql4dm/PgsqlResultSet/CallProcGet(function, ...)
	var/list/L                             = args.Copy(2)

	return call(world.system_type == MS_WINDOWS ? LIBPGSQL4DM_DLL_WIN32 : LIBPGSQL4DM_DLL_UNIX, function)(arglist(L))

#undef LIBPGSQL4DM_TRACKER_URL
