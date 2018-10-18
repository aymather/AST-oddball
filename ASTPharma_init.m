function settings = ASTPharma_init(data)

    % Trials
    if data.training == 0
        settings.general.trials = 3; % clusters
        settings.general.blocks = 6;
    else
        settings.general.trials = 1;
        settings.general.blocks = 1;
    end

    % Layout
    settings.layout.introsize = 40;
    settings.layout.color.fixation = [255 255 255];

    % Folders
    settings.files.infolder = fileparts(which('ASTPharma.m'));
    settings.files.outfolder = fullfile(infolder, 'out');
    clocktime = clock; hrs = num2str(clocktime(4)); mins = num2str(clocktime(5));
    settings.files.outfile = ['Subject_' num2str(data.nr) '_' date '_' hrs '.' mins 'h.mat'];
    settings.files.eyelink = ['AST_S' num2str(data.nr) '.edf'];

    % Sound
    settings.sound.srate = 16000;
    settings.sound.duration = .2;
    if rand <= .5
        settings.sound.stan_freq = 600;
        settings.sound.odd_freq = 1200;
    else
        settings.sound.stan_freq = 1200;
        settings.sound.odd_freq = 600;
    end
    asamples = 0:1/settings.sound.srate:settings.sound.duration;
    settings.stan_wave = sin(2* pi * settings.sound.stan_freq * asamples);
    settings.odd_wave = sin(2 * pi * settings.sound.odd_freq * asamples);
    load(fullfile(settings.files.infolder, 'backend', 'novelsounds.mat'));
    
    % Eyelink 
    settings.eyetracker = EyelinkInitDefaults(settings.screen.outwindow);
    if ~EyelinkInit(0, 1)
        Eyelink('Shutdown');
        sca;
        ListenChar(0);
        return;
    end
    Eyelink('Command', 'link_sample_data = LEFT,RIGHT,GAZE,AREA');
    Eyelink('Openfile', settings.files.edfFile);
    settings.eyetracker.srate = 1000;
    settings.eyetracker.minsac = 2;
    settings.eyetracker.minsac = 2;
    settings.eyetracker.srate = 1000;
    EyelinkDoTrackerSetup(settings.eyetracker);
    EyelinkDoDriftCorrection(settings.eyetracker);
    
    % EEG
    if data.eeg == 1
        EEGtrigger(0); 
        settings.eeg = 1; 
    else
        settings.eeg = 0; 
    end
    
    % Screen
    settings.screen.Number = max(Screen('Screens'));
    [settings.screen.outwindow, settings.screen.outwindowdims] = Screen('Openwindow',settings.screen.Number, 0); % make screen, black bg
    settings.screen.cm_d = 77; % distance from screen
    settings.screen.cm_h = 53.5; % horizontal

end