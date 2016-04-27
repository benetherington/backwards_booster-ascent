
function mode_discover { // Get info about this ship
  lexicon_engine().
  list_stages().
  find_fairings().
  global initial_roll to ship:facing:roll.
}

function mode_atmo_ascent { // Get pretty much anything into orbit
  // set throttle_limit_controller to pidloop(1, 0, 0, 0, 1).
  set time_to_ap_throt to pidloop(3, .18, .045, .1, 1). // TODO: need to tune for rediculously high thrust
  
  lock steering to up+r(0, calcpitch_ascent(), initial_roll).
  lock throttle to limit_throttle( time_to_ap_throt:update(time:seconds, time_to_nearest_ap() - target_time_to_ap()) ).
  // TODO: start with velocity limit until we're above ~10k, then switch to AP target.

  global stage_flag to 0. // disable auto-staging until we've activated the first stage.
  autostage().
  autostage_fairings(30000).




  stage. ///////////////////////////////////////////// LAUNCH!
  global mission_elapsed_time to time:seconds.
  global stage_flag to 1. // enable autostaging.

  // TODO: for low TWR vehicles, allow higher pitch when time to AP is slipping.

  // when ship:altitude>50000 and target_time_to_ap()<30 then {
  //   print "retuning kd".
  //   set time_to_ap_throt:kd to .06.
  // }

  wait until ship:apoapsis >= target_orbit_height. //TODO: for high TWR vehicles, pitch down near end of ascent burn? Maybe minimum throttle?
  lock throttle to 0.
  lock steering to heading(90, 0).

  print "ascent complete.".
}

function mode_circularize {
  // TODO: ask for remaining time in stage, ditch nearly empty ascent stages before circularizing?
  local expected_arrival to time:seconds + eta:apoapsis.
  local burn_time to circularize_approximation().
  set calcpitch_circ to pidloop(2.4, .5, 3, -100, -80). // TODO: re-tweak to account for new strategy

  lock steering to up+r(0, -90, initial_roll).
  RCS on.

  if burn_time > (eta:apoapsis * .9) {
    full_throttle_circ_burn(burn_time, expected_arrival).
  } else {
    half_throttle_circ_burn(burn_time, expected_arrival).
  }

  set stage_flag to 0.
  RCS off.
  print "circularize complete.".
}

function mode_onorbit { // Survive in space-ace-ace
  list_solar_deploy(). // TODO: refactor to push function into for/in?
  for panel in solar_deployable {
    panel:GETMODULE("ModuleDeployableSolarPanel"):DOEVENT("extend panels").
    wait 5.
  }
  unlock steering.
  set ship:control:pilotmainthrottle to 0.
  print "onorbit complete.".
}








