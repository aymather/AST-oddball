function settings = eye_calibrate(settings,initialcalibrate)

if initialcalibrate == 1
    Eyelink('StartRecording');
    % get visual angle
    onedegree = visualangle(2,settings.screen.cm_d,settings.eyetracker.minsac);
    percentofscreen = onedegree/settings.screen.cm_h;
    screenpixels = settings.screen.outwindowdims(3:4);
    onedegpix = round(screenpixels(1)*percentofscreen);
    screencenter = screenpixels(1)/2;
    maxsac = screenpixels(1)/2-15;
    calibtrials = 4;
    
    % positions
    calibpos = [repmat(onedegpix,1,calibtrials) repmat(-onedegpix,1,calibtrials)];
    calibpos = calibpos(randperm(length(calibpos))); % randomize
    calibpos = calibpos + screencenter; % center on screen
    
    % duration of fixation
    duration = 1;
    fixation = .75;
    srate = settings.eyetracker.srate;
    
    % calibrate
    sacdata = zeros(length(calibpos),duration*srate+1);
    diffsac = sacdata;
    for ip = 1:length(calibpos)
        
        % wavedaa
        wavedata = zeros(1,duration*srate+1);
        
        % Center
        Screen('DrawDots', settings.screen.outwindow, screenpixels/2, 20, [255 255 255]);
        starttime = Screen(settings.screen.outwindow,'Flip');
        WaitSecs(fixation);
        
        % Sac
        Screen('DrawDots', settings.screen.outwindow, [calibpos(ip),screenpixels(2)/2], 20, [255 255 255]);
        starttime = Screen(settings.screen.outwindow,'Flip');
        [data,emsg] = eye_getdata(settings,duration,starttime);
        
        % Store
        wavedata(1:size(data,2)) = data(1,:);
        missingsamples = length(wavedata) - size(data,2);
        if missingsamples > 0
            wavedata(size(data,2)+1:end) = data(1,end); % fill with last sample
        elseif size(wavedata,2) > size(sacdata,2)
            wavedata = wavedata(1:duration*srate+1);
        end
        disp(size(wavedata));
        sacdata(ip,:) = wavedata - min(wavedata); % normalized to 0
        diffsac(ip,:) = abs([0 diff(wavedata)]);
        
    end
    
    % close screen
    Screen('CloseAll');
    ShowCursor;
    Priority(0);
    ListenChar(0);
    
    % Display threshold and wait for confirmation
    h = figure('Position',[0 0 1000 800]); hold;
    inclusion = zeros(size(diffsac,1),1);
    for iw = 1:size(diffsac,1);
        
        Accel = diffsac(iw,:);
        Fixat = sacdata(iw,:);
        sacline = line(1:length(Accel),Accel,'Color','k','LineWidth',1);
        fixline = line(1:length(Fixat),Fixat,'Color','r','LineWidth',1);
        title(['Screen position: ' num2str(calibpos(iw))]);
        
        % ask if ok
        yn = questdlg(['Include current trial?'], ...
            'Y/N', ...
            'Yes','No','No');
        switch yn
            case 'Yes'
                inclusion(iw) = 1;
            case 'No'
                inclusion(iw) = 0;
        end

        delete(fixline);
        delete(sacline);

    end
    close all
    initialthreshold = min(max(diffsac(find(inclusion),1:size(diffsac,2)/2)'));
    settings.eyetracker.threshold = initialthreshold;
    disp(settings.eyetracker.threshold);
    Eyelink('StopRecording');
else settings.eyetracker.threshold = initialcalibrate;

end

Screen('CloseAll');
ShowCursor;
Priority(0);
[settings.screen.outwindow, settings.screen.outwindowdims] = Screen('Openwindow',settings.screen.Number, 0); % make screen, black bg
priorityLevel = MaxPriority(settings.screen.outwindow); % prioritize
Priority(priorityLevel);
HideCursor; % hide cursor
% prepare fonts
Screen('TextSize',settings.screen.outwindow,settings.layout.introsize);
Screen('TextFont',settings.screen.outwindow,'Arial'); % arial
Screen('TextStyle', settings.screen.outwindow, 0); % make normal