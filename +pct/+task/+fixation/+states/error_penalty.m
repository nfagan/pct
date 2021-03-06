function state = error_penalty(program, conf)

time_in = conf.TIMINGS.time_in;

state = ptb.State();
state.Name = 'error_penalty';

state.Duration = time_in.(state.Name);

state.Entry = @(state) entry(state, program);
state.Loop = @(state) loop(state, program);
state.Exit = @(state) exit(state, program);

end

function entry(state, program)

flip( program.Value.window );
debug_window_is_present = program.Value.debug_window_is_present;
if (debug_window_is_present)
  flip( program.Value.debug_window );
end

timestamp_entry( state, program );

end

function loop(state, program)

end

function exit(state, program)

states = program.Value.states;
timestamp_exit( state, program );
next( state, states('new_trial') );

end

function timestamp_entry(state, program)

program.Value.data.Value(end).(state.Name).entry_time = elapsed( program.Value.task );

end

function timestamp_exit(state, program)

program.Value.data.Value(end).(state.Name).exit_time = elapsed( program.Value.task );

end