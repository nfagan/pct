Screen( 'Preference', 'VisualDebuglevel', 0 );

conf = pct.config.reconcile( pct.config.load() );

conf.TIMINGS.time_in.fixation = 10;

conf.META.subject = 'hitch';

% conf.INTERFACE.gaze_source_type = 'analog_input';
conf.INTERFACE.gaze_source_type = 'digital_eyelink';
% conf.INTERFACE.gaze_source_type = 'mouse';
conf.INTERFACE.reward_output_type = 'ni'; 
% conf.INTERFACE.reward_output_type = 'none'; 
conf.INTERFACE.skip_sync_tests = true;

% conf.SCREEN.rect = [0, 0, 1280, 1024];
conf.SCREEN.rect = [];
conf.SCREEN.index = 3;
conf.SCREEN.calibration_rect = [0, 0, 1280, 1024];

conf.STIMULI.setup.fix_square.size = [100, 100];
conf.STIMULI.setup.patch.size = [100, 100];

conf.DEBUG_SCREEN.is_present = false;
conf.DEBUG_SCREEN.index = 0;
conf.DEBUG_SCREEN.background_color = [ 0 0 0 ];
% conf.DEBUG_SCREEN.rect = [ 600, 600, 1000, 1000 ];
conf.DEBUG_SCREEN.rect = [ 1600, 0, 1600 + 1280, 1024 ];

conf.REWARDS.training = 0.3;

pct.task.fixation.start( conf );