global target_orbit_height to 75000. // How high do you want to go today?

function calcpitch_ascent {
  if ship:altitude < 200 {
    return 90.
  } else {
    return ( 90-(ship:altitude/70000)*90 ).
  }
}


lock throttle to 1. // TODO: write throttle limiter (max g)
lock steering to heading( 90, calcpitch_ascent() ).

stage.

wait until ship:apoapsis >= target_orbit_height.
lock throttle to 0.
lock steering to heading(90,0).

print "ascent complete.".

// TODO: gather gravity turn data. Write staging trigger. Write circularization script.