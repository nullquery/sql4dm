var/nq_commons/CO = new

/*
	Usage: CO.GenerateUniqueID()

	This function guarantees a unique id. You can use this in database
	operations for the primary key column, or whenever you need to get
	a unique identifier for something.

	It uses the nq_utility library (DLL) to get the current time in
	milliseconds, storing the previous value. This is therefore not
	guaranteed to be the equivalent of the current time in milliseconds,
	but by utilizing that value no additional values are required.

	The result is a "mostly unique id" which can differ only if running
	the same world multiple times.

	If this is a concern (you are running multiple BYOND worlds and need
	them to have a 'true' unique id) you'll have to handle the coordination
	yourself as it falls outside the scope of this function.

	Note that the result is returned as text to bypass BYOND's limitation
	on numbers. It is not intended for mathematical operations.
*/
/nq_commons/proc/GenerateUniqueID() return nq_utility.GenerateUniqueID()

/nq_commons/var/list/last_action_hero

/*
	Usage: CO.LastActionHero(object, proc_name, timeout, atomic, ...)

	This function will execute [proc_name] on the object [object] in [timeout]
	ticks unless this proc is called again within that time.

	Calling this proc again with the same [object] and [proc_name] will negate
	a previous call to this proc, effectively allowing you to queue a proc
	call and ensure it is only executed once per [timeout] ticks.

	The [atomic] parameter determines if the proc may be executed while it is
	running. If you set this to FALSE the proc MAY run concurrently.
*/
/nq_commons/proc/LastActionHero(object, proc_name, timeout = 0, atomic = TRUE, ...)
	if (!last_action_hero)                last_action_hero = new/list()

	var/key                               = "\ref[object]_[proc_name]"

	if (!(key in last_action_hero))       last_action_hero[key] = 0

	if (last_action_hero[key] != -1)
		var/c                             = ++last_action_hero[key]

		if (timeout != 0)                 sleep (timeout)

		if (c == last_action_hero[key])
			var/list/arguments

			if (args.len > 4)             arguments = args.Copy(5)
			else                          arguments = list()

			if (atomic)                   last_action_hero[key] = -1
			else                          last_action_hero.Remove(key)

			call(object, proc_name)(arglist(arguments));

			if (atomic)                   last_action_hero.Remove(key)

			if (!last_action_hero.len)    last_action_hero = null

/nq_commons/var/sql4dm/DatabaseConnection/database_connection

/nq_commons/proc/SetDatabaseConnection(conn) database_connection = conn

/*
	Usage: CO.getDBV(query, ...)

	Note: Use CO.SetDatabaseConnection to set a database connection first!

	This is a convenience function that performs a query on the database
	and returns either the 1st column of the 1st row in the result or an
	empty string if ANY error occurred.

	Particularly useful if you don't care about errors but just want to
	get a value without the increased burden of performing queries and
	handling error conditions.

	Note: "DBV" stands for "DatabaseValue".
*/
/nq_commons/proc/GetDBV(query, ...)
	try
		var/sql4dm/ResultSet/rs            = database_connection.Query(arglist(args))

		if (rs.Next())                     return rs.GetString(1)
		else                               return "";
	catch ()                               return ""

/*
	Usage: CO.getDBVNumber(query, ...)

	The same as CO.getDBV but returns a number instead of a text string.
	Be wary of BYOND's limit on numbers!
*/
/nq_commons/proc/GetDBVNumber(query, ...)
	try
		var/sql4dm/ResultSet/rs            = database_connection.Query(arglist(args))

		if (rs.Next())                     return rs.GetNumber(1)
		else                               return 0
	catch ()                               return 0

/*
	Usage: CO.StartsWith(text, str)
	Usage: CO.StartsWith(text, str, case_sensitive)

	Returns 1 if the provided [text] starts with [str], 0 if not.
*/
/nq_commons/proc/StartsWith(text, str, case_sensitive = 0)
	if (case_sensitive) return findtextEx(text, str, 1, lentext(str) + 1)
	else                return findtext(text, str, 1, lentext(str) + 1)

/*
	Usage: CO.EndsWith(text, str)
	Usage: CO.EndsWith(text, str, case_sensitive)

	Returns 1 if the provided [text] ends with [str], 0 if not.
*/
/nq_commons/proc/EndsWith(text, str, case_sensitive = 0)
	if (case_sensitive) return findtextEx(text, str, -lentext(str))
	else                return findtext(text, str, -lentext(str))

/*
	Usage: CO.ReverseText(text)

	Returns the reverse of [text].
*/
/nq_commons/proc/ReverseText(text)
	var/result = ""

	for (var/i = length(text), i > 0, i = i - 1)  result = result + ascii2text(text2ascii(text, i))

	return result

/nq_commons/proc/_left(text, pos)
	if (pos > 0)        return copytext(text, 1, pos)
	else                return text

/nq_commons/proc/_right(text, pos)
	if (pos > 0)        return copytext(text, pos + 1)
	else                return text

/*
	Usage: CO.IndexOf(text, str)
	Usage: CO.IndexOf(text, str, case_sensitive)
	Usage: CO.IndexOf(text, str, case_sensitive, start)

	Convenience function that wraps the use of findtext and findtextEx.
*/
/nq_commons/proc/IndexOf(text, str, case_sensitive = 0, start = 1)
	var/pos

	if (case_sensitive)  pos = findtextEx(text, str, start)
	else                 pos = findtext(text, str, start)

	return pos

/*
	Usage: CO.ToProperCase(text)

	Converts [text] to proper case.

	Proper case is converting from "strings like THIS" to "Strings Like This"
*/
/nq_commons/proc/ToProperCase(text)
	if (length(text) > 1)
		var result           = uppertext(copytext(text, 1, 2))
		var old_pos          = 2
		var pos

		do
			pos              = CO.IndexOf(text, " ", start = old_pos)

			if (pos > 0)
				result       = result + lowertext(copytext(text, old_pos, pos)) + uppertext(copytext(text, pos, pos + 2))
				old_pos      = pos + 2
			else
				result       = result + lowertext(copytext(text, old_pos))
		while (pos)

		return result
	else                     return uppertext(text)

/*
	Usage: CO.Left(text, str)
	Usage: CO.Left(text, str, case_sensitive)

	Usage: CO.Right(text, str)
	Usage: CO.Right(text, str, case_sensitive)

	Usage: CO.BackwardsLeft(text, str)
	Usage: CO.BackwardsLeft(text, str, case_sensitive)

	Usage: CO.BackwardsRight(text, str)
	Usage: CO.BackwardsRight(text, str, case_sensitive)

	Returns the left or right side of [text] starting at the position of [str].

	Example:

	var/str = "Hello, world. I hope all is well with the world today."
	CO.Left(str, "world") // returns "Hello, "
	CO.Right(str, "world") // returns ". I hope all is well with the world today."
	CO.BackwardsLeft(str, "world") // returns "Hello, world. I hope all is well with the "
	CO.BackwardsRight(str, "world") // returns " today."

	The above example does not really showcase its usefulness well, but it can be
	quite useful when parsing text.
*/
/nq_commons/proc/Left(text, str, case_sensitive = 0)            return _left(text, CO.IndexOf(text, str, case_sensitive))
/nq_commons/proc/Right(text, str, case_sensitive = 0)           return _right(text, CO.IndexOf(text, str, case_sensitive))
/nq_commons/proc/BackwardsLeft(text, str, case_sensitive = 0)   return _left(text, length(text) - CO.IndexOf(CO.ReverseText(text), str, case_sensitive) + 1)
/nq_commons/proc/BackwardsRight(text, str, case_sensitive = 0)  return _right(text, length(text) - CO.IndexOf(CO.ReverseText(text), str, case_sensitive) + 1)

/nq_commons/var/const/NOMINATIVE = 1
/nq_commons/var/const/OBLIQUE = 2
/nq_commons/var/const/POSSESSIVE = 3
/nq_commons/var/const/REFLEXIVE = 4
/nq_commons/var/const/FORMAL = 5

/*
	CO.GetGenderPronoun(gender)
	CO.GetGenderPronoun(gender, subject)

	Returns the appropriate gender pronoun given a [gender] and a [subject].

	Use CO.NOMINATIVE, CO.OBLIQUE, CO.POSSESSIVE, CO.REFLEXIVE or CO.FORMAL
	for the [subject] parameter.
*/
/nq_commons/proc/GetGenderPronoun(gender, subject = NOMINATIVE)
	switch (subject)
		if (NOMINATIVE)
			switch (gender)
				if (MALE)      return "He"
				if (FEMALE)    return "She"
				if (NEUTER)    return "It"
				else           return "They" // PLURAL
		if (OBLIQUE)
			switch (gender)
				if (MALE)      return "Him"
				if (FEMALE)    return "Her"
				if (NEUTER)    return "It"
				else           return "Them" // PLURAL
		if (POSSESSIVE)
			switch (gender)
				if (MALE)      return "His"
				if (FEMALE)    return "Hers"
				if (NEUTER)    return "Its"
				else           return "Theirs" // PLURAL
		if (REFLEXIVE)
			switch (gender)
				if (MALE)      return "Himself"
				if (FEMALE)    return "Herself"
				if (NEUTER)    return "Itself"
				else           return "Themselves" // PLURAL
		if (FORMAL)
			switch (gender)
				if (MALE)      return "Sir"
				if (FEMALE)    return "Ma'am"
				else           CRASH("Operation not supported: [gender] in combination with FORMAL subject.")

/*
	Usage: CO.AddZeros(n, amount)

	Adds [amount] zeroes before the value [n] (may be a number or a text string).
*/
/nq_commons/proc/AddZeros(n, amount)
	var/result = "[n]"

	while (length(result) < amount) result = "0[result]"

	return result

/*
	Usage: CO.DirectionToString(dir)

	Returns the name of the direction passed.
*/
/nq_commons/proc/DirectionToString(dir)
	if (dir & NORTH) . = . + "north"
	if (dir & SOUTH) . = . + "south"
	if (dir & EAST)  . = . + "east"
	if (dir & WEST)  . = . + "west"

	return .