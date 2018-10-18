% EDITED BY JRW FOR ESCAPE
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
function eyetracker = eye_initialize(settings)
Eyelink('Initialize')
el = EyelinkInitDefaults(settings.screen.outwindow);

[v vs]=Eyelink('GetTrackerVersion');
fprintf('Running experiment on a ''%s'' tracker.\n', vs );

% make sure that we get gaze data from the Eyelink
Eyelink('Command', 'link_sample_data = LEFT,RIGHT,GAZE,DIAMETER');
% open file to record data to
    edfFile='demoast.edf';
    Eyelink('Openfile', edfFile);
% Calibrate the eye tracker
EyelinkDoTrackerSetup(el);

% do a final check of calibration using driftcorrection
EyelinkDoDriftCorrection(el);
    
eyetracker.srate = 120;
eyetracker.minsac = 3; % in deg of visual angle