/*
	Welcome to the sql4dm demo library. In this demo you will see how you can use SQL to allow
	your players to leave feedback. Later, you can query the feedback to filter and sort the results.
*/

/var/sql4dm/DatabaseConnection/db

/world/New()
	. = ..()

	// For the purposes of this demo we'll use an SQLite library.
	db = new/sql4dm/SqliteDatabaseConnection("test.db")

	// Alternatively if you have your own MySQL/MariaDB or PostgreSQL
	// server you can use the code below to connect to that instead.
	// (This is highly recommended for production use.)
	// db = new/sql4dm/MysqlDatabaseConnection("127.0.0.1", 3306, "root", "", "testdb")
	// db = new/sql4dm/PgsqlDatabaseConnection("127.0.0.1", 5432, "postgres", "", "testdb")

	// Load the "changelog.xml" file and process its contents.
	// This adds the 'feedback' table to the database. Open the "changelog.xml" that resides
	// in the same folder as this demo to see how this works.
	var/sql4dm/Changelog/changelog = new(db, "changelog.xml")

	changelog.Process()

// This proc is for convenience so we can quickly get a value from the database without
// having to write a lot of code. We'll use it later.
proc/GetDatabaseValue(query, ...)
	try
		var/sql4dm/ResultSet/rs = db.Query(arglist(args))

		if (rs.Next())
			return rs.GetString(1)
	catch (var/ex)
		throw ex

// The "print feedback" verb (intended for administrators) shows the feedback placed by any user.
mob/verb/print_feedback()
	try
		// db.Query returns a ResultSet object which contains the results of the query.
		var/sql4dm/ResultSet/rs = db.Query("SELECT title, author, message FROM feedback ORDER BY title")

		var/i = 0

		src << "Feedback:"

		// While we still have a result...
		while (rs.Next())
			// ...give the player the information from the result.
			src << "Row [++i]: \"[rs.GetString("title")]\" posted by [rs.GetString("author")]\nMessage: [rs.GetString("message")]"
	catch (var/ex)
		src << "An error occurred. Error message: [ex]"

// The "print my feedback" verb is just a copy of the "print feedback" verb, but with a modified query
// that filters the results so you only get the feedback made by the current player.
mob/verb/print_my_feedback()
	try
		// A slightly different query:
		//    - Use of the '*' specifier to get all fields instead of specific fields. Useful if you
		//      need everything in a table.
		//
		//    - Use of a WHERE statement to filter the result. In this case, we're filtering where the
		//      "author" field is the same as the current player's key.
		//
		//    - If a player has a key that looks like an SQL statement then it might accidentally be executed.
		//      We don't want that. To avoid it we specify the key as the 2nd parameter to the db.Query function
		//      and use the text "$1" to reference it. A bigger example of this is shown in the add_feedback verb.

		var/sql4dm/ResultSet/rs = db.Query("SELECT * FROM feedback WHERE author = $1 ORDER BY title", src.key)

		var/i = 0

		src << "Feedback (mine only):"

		// Same as before: loop over the results and print some text to the user.
		while (rs.Next())
			src << "Row [++i]: \"[rs.GetString("title")]\" posted by [rs.GetString("author")]\nMessage: [rs.GetString("message")]"
	catch (var/ex)
		src << "An error occurred. Error message: [ex]"

// The "add feedback" verb is used to add feedback.
mob/verb/add_feedback()
	// Ask the user their details: name and message.
	var/title = input(src, "What is the title of the feedback?") as null|text

	if (title != null)
		var/message = input(src, "What is your message?") as null|message

		if (message != null)
			// You may give feedback as yourself or on behalf of someone else.
			var/choice = alert(src, "Do you want to post this message as yourself, or as someone else?", "", "As myself ([src.key])", "As someone else", "Cancel")

			if (!(choice == null || choice == "Cancel"))
				var/key = src.key
				if (choice == "As someone else")
					// On behalf of someone else, so provide the key.
					key = input(src, "Which BYOND key do you want to post the feedback as?") as null|text

				if (key != null)
					// This statement inserts a new row into the "feedback" table.
					// Note the use of multiple parameters (each referenced in the query with "$1", "$2", etc.)
					db.Execute("INSERT INTO feedback (id, author, title, message) VALUES($1, $2, $3, $4)",
						GetDatabaseValue("SELECT COALESCE((SELECT MAX(id) FROM feedback), 0) + 1"), // Special case: see below
						key,
						title,
						message)

// The "GetDatabaseValue" bit has a slightly more complex query. It returns the total amount of rows in the "feedback" table + 1.
// However, there is a caveat: if there are no rows in the "feedback" table it will return null instead. This is a quirk of the SQL
// language. To avoid this we use the COALESCE function which returns the first non-null element it contains.
// i.e., COALESCE(null, null, 2, 3) will always return 2.
