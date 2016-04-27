set terminal:visualbeep to true.


global target_orbit_height to 75000.    // How high do you want to go?
global maximum_safe_Gs to 2.            // How fast do you want to get there?
global staging_cooldown_buffer to 2.    // How quickly should we stage? Handy for recovery.
//TODO: allow inclination selection
//TODO: allow coplanar launches


clearscreen. set ship:control:pilotmainthrottle to 0.

print "loading libraries into memory.".
run once lib_utilities.ks.
run once lib_discover.ks.
run once lib_atmo_ascent.ks.
run once lib_circularize.ks.
run once lib_onorbit.ks.
run once modes.ks.


mode_discover().
mode_circularize().