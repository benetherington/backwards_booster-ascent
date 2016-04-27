/////////////////// HANDY STUFF

function orbital_velocity {
  parameter target_alt.
  return sqrt( (constant:G * kerbin:mass) / (kerbin:radius + target_alt) ).
}

function time_to_nearest_ap { // allows negative ETA:apoapsis
  if (ship:orbit:period - ETA:apoapsis) > (ship:orbit:period / 2) {
    return ETA:apoapsis.  // we're approaching AP!
  } else {
     return 0 - (ship:orbit:period - ETA:apoapsis).  // we're past AP!
  }
}

function circularize_approximation { // figure out how long the circularization burn will take
  local dv_needed to orbital_velocity(target_orbit_height) - velocityat(ship, time + ETA:apoapsis):orbit:mag. // TODO: allow custom target orbit eccentricity
  local momentary_acceleration to ship:availablethrust/ship:mass.

  return dv_needed/momentary_acceleration. // NOTE: divide by zero if no active engines!
}


function print_corner { parameter text. parameter mode. // 1: upper-left, 2: upper-right, 3: lower-left, 4: lower-right
  local row to 0.
  local col to 0.

  local text to "" + text.

  if mode = 2 or mode = 4 { set col to terminal:width - text:length. }
  if mode = 3 or mode = 4 { set row to terminal:height - 2. }

  print text at (col, row).
}

function countdown_inline { // print the number of seconds from now to a target time.
  parameter target_time.

  if not (defined previous_time) {
    local previous_time to time:seconds.
  }

  if not (defined inline_previous_time) {
    global inline_previous_time to time:seconds. // TODO: allow multiple counters at once. Big scope issue.
  }

  if time:seconds - inline_previous_time > 1 {
    print (-1 * floor(time:seconds - target_time)).
    set inline_previous_time to time:seconds.
  }
}

function countdown_corner { // print the number of seconds from now to a target time in a corner.
  parameter target_time, corner.

  if not (defined corner_previous_time) {
    global corner_previous_time to time:seconds. // TODO: allow multiple counters at once. Big scope issue.
  }

  if time:seconds - corner_previous_time > 1 { // TODO: make sure first number prints correctly. TODO: make sure losing a digit works.
    print_corner("  ", corner).
    print_corner( (-1 * floor(time:seconds - target_time)), corner).
    set corner_previous_time to time:seconds.
  }
}

// TODO: text wrapping function.








