function [data,emsg] = eye_getdata(settings,duration,starttime,dot)

% inputs
if nargin < 4 || dot == 0
    doff = 1;
else doff = 0;
end

is = 0; emsg = ''; data = []; 
try 

    while duration > (GetSecs - starttime)

        if Eyelink('NewFloatSampleAvailable')
          
            is = is + 1;

            % get sample
            SAMPLE = Eyelink( 'NewestFloatSample');
            x0 = SAMPLE.gx(2);
            y0 = SAMPLE.gy(2);
            dia = SAMPLE.pa(2);
            
            data(1,is) = x0;
            data(2,is) = GetSecs - starttime;
            data(3,is) = dia;
            
            % display dot on screen
            if doff == 0
				Screen('DrawDots', settings.screen.outwindow, [x0,y0], 20, [0 255 0])
				Screen(settings.screen.outwindow, 'Flip')
            end
        end
    end

catch    
    emsg = lasterror;
end
