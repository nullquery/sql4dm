/*
    nq_utility: Utility / misc. operations
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

#ifndef LIBNQUTILITY_DLL_WIN32
#define LIBNQUTILITY_DLL_WIN32 "./libnqutility.dll"
#endif

#ifndef LIBNQUTILITY_DLL_UNIX
#define LIBNQUTILITY_DLL_UNIX "./libnqutility.so"
#endif

/var/nq_utility/nq_utility = new

/nq_utility/proc/CallProc(function, ...)
	var/list/L										= args.Copy(2)

	return call(world.system_type == MS_WINDOWS ? LIBNQUTILITY_DLL_WIN32 : LIBNQUTILITY_DLL_UNIX, function)(arglist(L))

/nq_utility/proc/GenerateUniqueID()
	return CallProc("getUniqueID")

