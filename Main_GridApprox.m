%%  File Name: Main_GridApprox.m
%  Description: Synchronizing datas (Brain CAN.csv, FlexRay.csv, CANoe.mat
%  Copyright(C) 2017 ACE Lab, All Right Reserved.
% *************************************************************************
clearvars; close all; clc;

%% Configuration
IsErrorModelExtraction = false;

%% [Step 1] Load data
try
    % load the previous path *.mat file
    load PrevPath_Analysis;
    % File path select from ui window with previous file path
    [Filename, Pathname] = uigetfile('*.mat', 'Select MAT File to Analyze', data_path);
catch err
    % File path select from ui window
    [Filename, Pathname] = uigetfile('*.mat', 'Select MAT File to Analyze');
end

data_path = [Pathname,Filename];
save('PrevPath_Analysis','data_path')
fprintf('  - Data loading... ');
load(data_path);

file_path = uigetdir('Set Path to save configuration file');
fprintf('[Complete]\n');
%%  1.1. Init
if IsErrorModelExtraction == false
    ans_sensor = input('  - Select sensor type (0:Delphi, 1:Mobileye, 2:FusionBox):');
    
    Source_GridApprox
else
    for nSensorIdx = 0:2
        ans_sensor = nSensorIdx;
        Source_GridApprox
    end
end






