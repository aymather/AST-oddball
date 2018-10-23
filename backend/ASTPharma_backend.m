function ASTPharma_backend(settings,trialseq,id)
    
    for it = 1:size(trialseq,1)
        
        if it == 1
            if trialseq(it,id.sound) == 1
                wavdata = settings.stan_wave;
            elseif trialseq(it,id.sound) == 2
                wavdata = settings.odd_wave;
            elseif trialseq(it,id.sound) == 3
                wavdata = novelsounds{1,randi([1,120],1,1)};
            end 
            PsychPortAudio('FillBuffer', settings.sound.audiohandle, wavdata);
        end
        
        if it == 1
            glo_intro(settings.screen.outwindow)
        end
        
        DrawFormattedText(settings.screen.outwindow, '+', 'center', 'center', settings.layout.color.fixation);
        Screen('Flip', settings.screen.outwindow);
        
        % Play audio for 200 ms
        stimstart = PsychPortAudio('Start', settings.sound.audiohandle, 1, 0, 1);
        
        while GetSecs - stimstart <= settings.durations.stim
            WaitSecs(0.001);
        end
        
        PsychPortAudio('Stop', settings.sound.audiohandle, 1);
        
        if trialseq(it+1,id.sound) == 1
            wavdata = settings.stan_wave;
        elseif trialseq(it+1,id.sound) == 2
            wavdata = settings.odd_wave;
        elseif trialseq(it+1,id.sound) == 3
            wavdata = novelsounds{1,randi([1,120],1,1)};
        end
        
        PsychPortAudio('FillBuffer', settings.sound.audiohandle, wavdata);
        
        WaitSecs(settings.durations.sound_delay);
        
    end

end