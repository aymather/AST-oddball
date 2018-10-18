% GazeContingent.m
%
% This script shows how to connect to SMI eye tracking application, 
% calibrate the eye tracker and draw the gaze data on the screen 
%
% for running this script the psych toolbox for Matlab needed 
% http://psychtoolbox.org
%
% Author: SMI GmbH
% June, 2012

%===========================
%Initialisation
%===========================

%clear all variables, connections, ...
clear all
clc
warning('off', 'all');

connected = 0;

% load the iViewX API library
loadlibrary('C:\Program Files\SMI\iViewXSDK_31\bin\iViewXAPI.dll', 'C:\Program Files\SMI\iViewXSDK_31\include\iViewXAPI.h');


[pSystemInfoData, pSampleData, pEventData, pAccuracyData, CalibrationData] = InitiViewXAPI();

CalibrationData.method = int32(5);
CalibrationData.visualization = int32(1);
CalibrationData.displayDevice = int32(0);
CalibrationData.speed = int32(0);
CalibrationData.autoAccept = int32(1);
CalibrationData.foregroundBrightness = int32(250);
CalibrationData.backgroundBrightness = int32(230);
CalibrationData.targetShape = int32(2);
CalibrationData.targetSize = int32(20);
CalibrationData.targetFilename = int8('');
pCalibrationData = libpointer('CalibrationStruct', CalibrationData);


disp('Define Logger')
calllib('iViewXAPI', 'iV_SetLogger', int32(1), formatString(256, int8('iViewXSDK_Matlab_GazeContingent_Demo.txt')))


disp('Connect to iViewX')
%calllib('iViewXAPI', 'iV_Connect', int8('169.254.253.181'), int32(4444), int8('169.254.194.53'), int32(5555))
ret = calllib('iViewXAPI', 'iV_Connect', formatString(16, int8('169.254.253.181')), int32(4444), formatString(16, int8('169.254.194.53')), int32(5555))
switch ret
    case 1
        connected = 1;
    case 104
         msgbox('Could not establish connection. Check if Eye Tracker is running', 'Connection Error', 'modal');
    case 105
         msgbox('Could not establish connection. Check the communication Ports', 'Connection Error', 'modal');
    case 123
         msgbox('Could not establish connection. Another Process is blocking the communication Ports', 'Connection Error', 'modal');
    case 200
         msgbox('Could not establish connection. Check if Eye Tracker is installed and running', 'Connection Error', 'modal');
    otherwise
         msgbox('Could not establish connection', 'Connection Error', 'modal');
end


if connected

	disp('Get System Info Data')
	calllib('iViewXAPI', 'iV_GetSystemInfo', pSystemInfoData)
	get(pSystemInfoData, 'Value')


	disp('Calibrate iViewX')
	calllib('iViewXAPI', 'iV_SetupCalibration', pCalibrationData)
	calllib('iViewXAPI', 'iV_Calibrate')


	disp('Validate Calibration')
	calllib('iViewXAPI', 'iV_Validate')


	disp('Show Accuracy')
	calllib('iViewXAPI', 'iV_GetAccuracy', pAccuracyData, int32(0))
	get(pAccuracyData,'Value')


	exitLoop = 0;
	try 

		% define screen, needs to be adjusted to different stimulus screens
		window = Screen('OpenWindow', 0);
		HideCursor;  

		while ~(exitLoop)         
            if (calllib('iViewXAPI', 'iV_GetEvent', pEventData) == 1)
                Evt = libstruct('EventStruct', pEventData);
                
                x0 = Evt.positionX;
                y0 = Evt.positionY;
                Screen('DrawDots',window,[x0 y0], 10, [0 255 0]);
            end
            
			if (calllib('iViewXAPI', 'iV_GetSample', pSampleData) == 1)

				% get sample
				Smp = libstruct('SampleStruct', pSampleData);

				x0 = Smp.leftEye.gazeX;
				y0 = Smp.leftEye.gazeY;
				Screen('DrawDots', window, [x0,y0], 20, [0 0 0])
				Screen(window, 'Flip')
				pause(0.01);

			end        

			% end experiment after a mouse button has been pushed
			if (waitForMouseNonBlocking)
				exitLoop = 1;
			end
		end

	catch
		% catch if errors appears
		Screen('CloseAll'); 
		ShowCursor
		s = lasterror
	end
end

disp('Disconnect')

% release screen
Screen('CloseAll'); 
ShowCursor

% disconnect from iViewX 
calllib('iViewXAPI', 'iV_Disconnect')

pause(1);
clear all

% unload iViewX API libraray
unloadlibrary('iViewXAPI');


