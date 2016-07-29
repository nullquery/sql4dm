/*
    sqlite4dm: SQLite database operations for BYOND worlds
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

/sql4dm/SqliteDatabaseConnection/parent_type = /sql4dm/DatabaseConnection
/sql4dm/SqliteDatabaseConnection/dbtype = "sqlite"

/sql4dm/SqliteDatabaseConnection/var/database/db

/sql4dm/SqliteDatabaseConnection/New(file)
	db = new(file)

/sql4dm/SqliteDatabaseConnection/Dispose()
	db.Close()

/sql4dm/SqliteDatabaseConnection/proc/GetArgList(query, list/arguments)
	var/list/L = new/list()
	var/regex/p = regex("\\$(\\d+)")

	while (p.Find(query))
		query = p.Replace(query, "?")
		L.Add(arguments[text2num(p.group[1]) + 1])

	L.Insert(1, query)

	return L

/sql4dm/SqliteDatabaseConnection/Execute(query, ...)
	var/database/query/q                   = new(arglist(GetArgList(query, args)))

	if (q.Execute(db))                     return q.RowsAffected()
	else                                   throw EXCEPTION(q.ErrorMsg())

/sql4dm/SqliteDatabaseConnection/Query(query, ...)
	var/database/query/q                   = new(arglist(GetArgList(query, args)))

	if (q.Execute(db))                     return new/sql4dm/SqliteResultSet(q)
	else                                   throw EXCEPTION(q.ErrorMsg())

/sql4dm/SqliteResultSet/parent_type = /sql4dm/ResultSet

/sql4dm/SqliteResultSet/var/database/query/q
/sql4dm/SqliteResultSet/var/position = 0
/sql4dm/SqliteResultSet/var/max_position = -1
/sql4dm/SqliteResultSet/var/list/columns

/sql4dm/SqliteResultSet/New(database/query/q)
	src.q = q

/sql4dm/SqliteResultSet/Dispose()
	src.q = null

/sql4dm/SqliteResultSet/CallProcResult(function, ...)
	throw EXCEPTION("Unsupported operation.")

/sql4dm/SqliteResultSet/CallProcGet(function, ...)
	throw EXCEPTION("Unsupported operation.")

/sql4dm/SqliteResultSet/Next()
	position++
	. = q.NextRow()
	if (!.) max_position = position

/sql4dm/SqliteResultSet/Previous()
	position--
	q.Reset()
	for (var/i = 1 to position) q.NextRow()

/sql4dm/SqliteResultSet/IsBeforeFirst()
	return position <= 0

/sql4dm/SqliteResultSet/IsAfterLast()
	if (max_position == -1)
		return 0
	else
		return position >= max_position

/sql4dm/SqliteResultSet/IsFirst()
	return position == 1

/sql4dm/SqliteResultSet/IsLast()
	return max_position == -1 ? 0 : (position + 1 == max_position)

/sql4dm/SqliteResultSet/First()
	q.Reset()
	Next()

/sql4dm/SqliteResultSet/Last()
	if (max_position == -1)
		while (Next() && max_position == -1) ...

	q.Reset()
	for (var/i = 1 to max_position) Next()

/sql4dm/SqliteResultSet/GetColumnNumber(column)
	if (columns == null) columns = q.Columns()

	return columns.Find(column)

/sql4dm/SqliteResultSet/GetString(column)
	if (isnum(column))
		return "[q.GetColumn(column)]"
	else
		return GetString(GetColumnNumber(column))
