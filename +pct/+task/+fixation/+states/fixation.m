function state = fixation(program, conf)

time_in = conf.TIMINGS.time_in;

state = ptb.State();
state.Name = 'fixation';

state.Duration = time_in.(state.Name);

state.Entry = @(state) entry(state, program);
state.Loop = @(state) loop(state, program);
state.Exit = @(state) exit(state, program);

end

function entry(state, program)

% Reset fix acquired state and target state.
state.UserData.fixation_acquired_state = fixation_acquired_state();
reset( program.Value.targets.fix_square );
timestamp_entry( state, program );
update_last_state( state, program );

end

function loop(state, program)

draw_target( program );
draw_cursor( program );
flip( program.Value.window );

debug_window_is_present = program.Value.debug_window_is_present;
if (debug_window_is_present)
  draw_debug_target( program );
  draw_debug_cursor( program );
  flip( program.Value.debug_window );
end

check_target( state, program );

end

function exit(state, program)

fix_acq_state = state.UserData.fixation_acquired_state;

if ( fix_acq_state.Acquired )
  timestamp_exit( state, program );
  did_fixate( state, program, fix_acq_state.Acquired );
  next( state, program.Value.states('fix_hold_patch') );
else
  timestamp_exit( state, program );
  did_fixate( state, program, fix_acq_state.Acquired );
  next( state, program.Value.states('error_penalty') );
end

end

function fix_state = fixation_acquired_state()

fix_state = struct();
fix_state.Acquired = false;
fix_state.Entered = false;
fix_state.Broke = false;

end

function timestamp_entry(state, program)

program.Value.data.Value(end).(state.Name).entry_time = elapsed( program.Value.task );

end

function timestamp_exit(state, program)

program.Value.data.Value(end).(state.Name).exit_time = elapsed( program.Value.task );

end

function update_last_state(state, program)

program.Value.data.Value(end).last_state = 'fix';

end

function draw_target(program)

is_debug = pct.util.is_debug( program );
window = program.Value.window;
fix_square = program.Value.stimuli.fix_square;
fix_target = program.Value.targets.fix_square;

draw( fix_square, window );

if ( is_debug )
  draw( fix_target.Bounds, window );
end

end

function draw_cursor(program)

is_debug = pct.util.is_debug( program );
pct.util.draw_gaze_cursor( program, is_debug );

end

function draw_debug_target(program)

window = program.Value.debug_window;
fix_square = program.Value.stimuli.fix_square;
fix_target = program.Value.targets.fix_square;

draw( fix_square, window );
draw( fix_target.Bounds, window );

end

function draw_debug_cursor(program)

is_debug = true;
pct.util.draw_gaze_cursor( program, is_debug );

end

function check_target(state, program)

fix_target = program.Value.targets.fix_square;
fix_acq_state = state.UserData.fixation_acquired_state;

if ( fix_target.IsDurationMet )
  % Looked for long enough, so proceed to the exit function.
  fix_acq_state.Acquired = true;
  escape( state );
  
elseif ( fix_target.IsInBounds )
  % Mark that we entered the target.
  fix_acq_state.Entered = true;
  
elseif ( fix_acq_state.Entered )
  % Looked away from the target, so proceed to the exit function.
  fix_state.Broke = true;
  escape( state );
end

state.UserData.fixation_acquired_state = fix_acq_state;

end

function did_fixate(state,program,fix_acq_state)

program.Value.data.Value(end).(state.Name).did_fixate = fix_acq_state;
  
end