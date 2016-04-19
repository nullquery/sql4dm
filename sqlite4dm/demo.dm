// Use the following to get started. This assumes you have an existing SQLite database called "testdb.db"

/proc/main()
	try
		// Open a new connection.
		var/sql4dm/SqliteDatabaseConnection/conn = new("testdb.db")

		// Perform a query. We'll assume the table "test" has three columns:
		// "id" (primary key, bigint) and "val" (character varying), "amount" (numeric)
		var/sql4dm/ResultSet/rs = conn.Query("SELECT * FROM test WHERE id = $1", "123")

		var/i = 0

		// Loop through the elements in the ResultSet
		while (rs.Next())
			world.log << "Row [++i]"

			world.log << "ID: [rs.GetString("id")]" // print the ID. Note that we use getString because of BYOND's limit on numbers
			                                        // (otherwise it will show the wrong number / scientific notation)
			world.log << "val: [rs.GetString("val")]"
			world.log << "amount: [rs.GetString("amount")] / [rs.GetNumber("amount")]" // use of getNumber to get a proper number (isnum will return 1)
			world.log << ""
		world.log << "Done"
	catch (var/ex)
		/*
		 * This could occur if:
		 *  - There was a connection error. Note that if a connection is interrupted prematurely the library
		 *    will attempt to reconnect, but will fail if this is unsuccessful.
		 *  - There was an error in the query (e.x., table does not exist).
		 *  - There was an error fetching results from the ResultSet (e.x., column does not exist).
		*/
		//world.log << "EXCEPTION: [ex]"
		throw ex

	// No need to close the ResultSet; this is done by the garbage collector.
	// No need to close the Connection; this is done by the garbage collector.

/world/New()
	. = ..()

	spawn (10) main()
