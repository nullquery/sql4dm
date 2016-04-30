/*
Notes:

- If your project uses no maps whatsoever then it MUST have a "blank.dmm" file
  with a minimum size of 1x1x1, otherwise BYOND will refuse to load any maps!

*/

// Some map definitions...
/obj/tomato
	icon = 'test.dmi'
	icon_state = "tomato"

/turf
	icon = 'test.dmi'
	var/testvar

/turf/white/icon_state = "white"
/turf/black/icon_state = "black"

/area/a
	Entered(mob/M)
		M << "You have entered area A"
/area/b
	Entered(mob/M)
		M << "You have entered area B"

// Need to set world.view manually because otherwise BYOND will decide it's 1x1
/world/view = "15x15"

// No reason, just prefer to set it higher for smoother movement.
/world/fps = 20

// Initialize the dynamically map upon loading.
/world/New()
	nq_dmm.LoadMap("test.dmm")

	. = ..()
