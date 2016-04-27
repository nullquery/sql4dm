/*
    nq_rand: Random number generator
    Copyright (C) 2016  NullQuery (http://www.byond.com/members/NullQuery)

    This program is part of the nq_utility library.

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

/nq_rand/var/global/last_id = 0
/nq_rand/var/id
/nq_rand/var/max_decimals = 5

/nq_rand/New(seed)
	. = ..()
	id = ++last_id
	if (seed) Seed(seed)

/nq_rand/Del()
	nq_utility.CallProc("destroyRandomGenerator", "[id]")
	return ..()

/nq_rand/proc/Seed(seed)
	return nq_utility.CallProc("setRandSeed", "[id]", "[seed]") == "0"

/nq_rand/proc/MaxDecimals(max_decimals)
	src.max_decimals = max_decimals

/nq_rand/proc/Random(a, b)
	. = nq_utility.CallProc("getRandomNumber", "[id]", "[a]", "[b]", "[max_decimals]")

	if (. == null || . == "")
		CRASH("Unable to generate next random number!")
	else
		return text2num("[.]")
