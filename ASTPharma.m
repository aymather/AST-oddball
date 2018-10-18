% % % % % % % % % % % % % % % % % % % % % % % % % % % %
%
% AST Pharma
%
% Program Written by: Jan R. Wessel
% Edited and adapted by: Alec Mather
%
% October 2018
% Matlab/Psychtoolbox/Eyelink
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % %

% Clean
clear;clc;
commandwindow;

% Get path
addpath(genpath(fileparts(which('AST2.m'))));

% Data columns
id = ASTPharma_columns;

% Get Data
data = ASTPharma_data;

% Settings
settings = ASTPharma_init(data);
settings = eye_calibrate(settings,1);





