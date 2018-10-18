disp('Disconnect')
Eyelink('Shutdown');
% release screen
Screen('CloseAll'); 
ShowCursor

pause(1);
clear all

% unload iViewX API libraray
%unloadlibrary('iViewXAPI');