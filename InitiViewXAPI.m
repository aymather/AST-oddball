% iViewXAPI.m
%
% Initializes iViewX API structures
%
% Author: SMI GmbH
% June, 2012

%===========================
%==== Function definition
%===========================

function [pSystemInfoData, pSampleData, pEventData, pAccuracyData, Calibration] = InitiViewXAPI()


%===========================
%==== System Info
%===========================

SystemInfo.samplerate = int32(0);
SystemInfo.iV_MajorVersion = int32(0);
SystemInfo.iV_MinorVersion = int32(0);
SystemInfo.iV_Buildnumber = int32(0);
SystemInfo.API_MajorVersion = int32(0);
SystemInfo.API_MinorVersion = int32(0);
SystemInfo.API_Buildnumber = int32(0);
SystemInfo.iV_ETDevice = int32(0);
pSystemInfoData = libpointer('SystemInfoStruct', SystemInfo);


%===========================
%==== Eye data
%===========================

Eye.gazeX = double(0);
Eye.gazeY = double(0);
Eye.diam = double(0);
Eye.eyePositionX = double(0);
Eye.eyePositionY = double(0);
Eye.eyePositionZ = double(0);


%===========================
%==== Online Sample data
%===========================

Sample.timestamp = int64(0);
Sample.leftEye = Eye;
Sample.rightEye = Eye;
Sample.planeNumber = int32(0);
pSampleData = libpointer('SampleStruct', Sample);


%===========================
%==== Online Event data
%===========================

Event.eventType = int8('F');
Event.eye = int8('l');
Event.startTime = double(0);
Event.endTime = double(0);
Event.duration = double(0);
Event.positionX = double(0);
Event.positionY = double(0);
pEventData = libpointer('EventStruct', Event);


%===========================
%==== Accuracy data
%===========================

Accuracy.deviationLX = double(0);
Accuracy.deviationLY = double(0);
Accuracy.deviationRX = double(0);
Accuracy.deviationRY = double(0);
pAccuracyData = libpointer('AccuracyStruct', Accuracy);


%===========================
%==== Calibration data
%===========================

Calibration.method = int32(5);
Calibration.visualization = int32(1);
Calibration.displayDevice = int32(0);
Calibration.speed = int32(0);
Calibration.autoAccept = int32(1);
Calibration.foregroundBrightness = int32(20);
Calibration.backgroundBrightness = int32(239);
Calibration.targetShape = int32(1);
Calibration.targetSize = int32(15);
Calibration.targetFilename = int8([0:255] * 0 + 30);





