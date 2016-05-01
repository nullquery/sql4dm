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

// Need to set world.view manually or BYOND will assume we have no map
/world/view = "15x15"

// No reason, just prefer to set it higher for smoother movement.
/world/fps = 20

// Initialize the dynamically map upon loading.
/world/New()
	nq_dmm.LoadMap("test.dmm")

	. = ..()

mob/verb/save_map()
	// Saves the current map (excluding mobs with keys) to a file called "test_out.dmm"
	// You can open this file with Dream Maker later to edit your map.
	// Note that this does not save transformations, overlays and underlays (due to internal formats)
	// which means it also won't save turfs that were stacked on top of each other using the map editor
	// (as this process uses underlays -- you must have no more or less than 1 turf per tile).
	nq_dmm.SaveMap("test_out.dmm", locate(1, 1, 1), locate(world.maxx, world.maxy, 1))
