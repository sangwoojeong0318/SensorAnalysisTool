%%  File Name: Main_DataSyncronizor.m
%  Description: Synchronizing datas (Brain CAN.csv, FlexRay.csv, CANoe.mat
%  Copyright(C) 2017 ACE Lab, All Right Reserved.
% *************************************************************************
clearvars; close all; clc;

%% [Step 0] Parameter Configuration
db_FlexRay_mat_Path = 'DB\AutonomousFlexRay_DB.mat';
dValidationGate = 10.; %[m]
dResamplingInterval = 0.01; %[sec]

% calibration parameter configuration
Delphi_offsetX = 3.8;
Mobileye_offsetX = 3.8;
%% [Step 1] Data import
fprintf('\n\n\n= [Step 1: Data loading] Load logging file\n');
%%   1.1. Brain Flexray import (*.csv -> workspace)
% Previous path load *.csv file
IsPreviousFile_FlexRay = false;
File_filename = '\FlexRay.csv';
try
    % load the previous path *.mat file
    load Previous_Data_Path;
    % File path select from ui window with previous file path
    File_path = uigetdir(File_path,'Set Brain data directory');
catch
    % File path select from ui window
    File_path = uigetdir('Set Brain data directory');
end
save('Previous_Data_Path','File_path');
FlexRay_Logging_csv_path = [File_path, File_filename];

if exist(FlexRay_Logging_csv_path,'file') == 0
    warning(['No file "',File_filename(2:end),'" \n']);
    return;
end



if exist([FlexRay_Logging_csv_path(1:end-3),'mat'],'file') ~= 0
    IsPreviousFile_FlexRay = true;
end

if IsPreviousFile_FlexRay == false
    BrainLogged_FlexRayFrame_Byte = Fn_BrainFlexRayParsing(db_FlexRay_mat_Path, FlexRay_Logging_csv_path);
    BrainFlexRayFrames_Byte = BrainLogged_FlexRayFrame_Byte;
    BrainFlexRayFrames = Fn_FlexRayParsingFromByte(BrainLogged_FlexRayFrame_Byte);
    
    save([FlexRay_Logging_csv_path(1:end-3),'mat'], 'BrainFlexRayFrames');
else
    load([FlexRay_Logging_csv_path(1:end-3),'mat']);
    fprintf(['  - [Info] Data was loaded from "',File_filename(2:end-3),'mat". If you do not want to load from this file, remove it\n']);
end
fprintf(['  - [Info] Brain data time: ', num2str(BrainFlexRayFrames.FrMsgOEM6_Time.OEM6_UTC_Hour(1)+9),':',...
    num2str(BrainFlexRayFrames.FrMsgOEM6_Time.OEM6_UTC_Minuite(1)),':',...
    num2str(BrainFlexRayFrames.FrMsgOEM6_Time.OEM6_UTC_Second(1)), ...
    ' ~ ',num2str(BrainFlexRayFrames.FrMsgOEM6_Time.OEM6_UTC_Hour(end)+9),':',...
    num2str(BrainFlexRayFrames.FrMsgOEM6_Time.OEM6_UTC_Minuite(end)),':',...
    num2str(BrainFlexRayFrames.FrMsgOEM6_Time.OEM6_UTC_Second(end)),'\n']);    
%%   1.2. Delphi import (*.csv -> workspace)
% Previous path load *.csv file
IsPreviousFile_Delphi = false;
File_filename = '\Delphi.csv';
Delphi_Logging_csv_path = [File_path, File_filename];

if exist(Delphi_Logging_csv_path,'file') == 0
    warning(['No file "',File_filename(2:end),'" \n']);
    return;
end

if exist([Delphi_Logging_csv_path(1:end-3),'mat'],'file') ~= 0
    IsPreviousFile_Delphi = true;
end

if IsPreviousFile_Delphi == false
    Delphi_DataFrames = Fn_DelphiDataParsing(Delphi_Logging_csv_path);
    
    save([Delphi_Logging_csv_path(1:end-3),'mat'], 'Delphi_DataFrames');
else
    load([Delphi_Logging_csv_path(1:end-3),'mat']);
    fprintf(['  - [Info] Data was loaded from "',File_filename(2:end-3),'mat". If you do not want to load from this file, remove it\n']);
end

% Invalid object remove
for nIndex = 1:size(Delphi_DataFrames.DynObjList.nID,1)
    for nObjIdx = 1:size(Delphi_DataFrames.DynObjList.nID,2)
        if (Delphi_DataFrames.DynObjList.X_m(nIndex,nObjIdx) == 0) && (Delphi_DataFrames.DynObjList.Y_m(nIndex,nObjIdx) == 0)
            Delphi_DataFrames.DynObjList.nID(nIndex,nObjIdx) = NaN;
        end
    end
end
%%   1.3. Mobileye import (*.csv -> workspace)
% Previous path load *.csv file
IsPreviousFile_Mobileye = false;
File_filename = '\Mobileye.csv';
Meye_Logging_csv_path = [File_path, File_filename];

if exist(Meye_Logging_csv_path,'file') == 0
    warning(['No file "',File_filename(2:end),'" \n']);
    return;
end

if exist([Meye_Logging_csv_path(1:end-3),'mat'],'file') ~= 0
    IsPreviousFile_Mobileye = true;
end

if IsPreviousFile_Mobileye == false
    Mobileye_DataFrames = Fn_MobileyeDataParsing(Meye_Logging_csv_path);
    
    save([Meye_Logging_csv_path(1:end-3),'mat'], 'Mobileye_DataFrames');
else
    load([Meye_Logging_csv_path(1:end-3),'mat']);
    fprintf(['  - [Info] Data was loaded from "',File_filename(2:end-3),'mat". If you do not want to load from this file, remove it\n']);
end
%%   1.4. Brain FusionBox data import (*.csv -> workspace)
% Previous path load *.csv file
IsPreviousFile_FusionBox = false;
File_filename = '\FusionBox.csv';
FusionBox_Logging_csv_path = [File_path, File_filename];

if exist(FusionBox_Logging_csv_path,'file') == 0
    warning(['No file "',File_filename(2:end),'" \n']);
    return;
end


if exist([FusionBox_Logging_csv_path(1:end-3),'mat'],'file') ~= 0
    IsPreviousFile_FusionBox = true;
end

if IsPreviousFile_FusionBox == false
    FusionBox_DataFrames = Fn_FusionBoxParsing(FusionBox_Logging_csv_path);
    
    save([FusionBox_Logging_csv_path(1:end-3),'mat'], 'FusionBox_DataFrames');
else
    load([FusionBox_Logging_csv_path(1:end-3),'mat']);
    fprintf(['  - [Info] Data was loaded from "',File_filename(2:end-3),'mat". If you do not want to load from this file, remove it\n']);
end
%%   1.5. CANoe data import (*.mat -> workspace)
% load the previous path *.mat file
try
    load PrevLoggingCANoePath;
    % File path select from ui window with previous file path
    [file,path] = uigetfile('*.mat','< Load the CANoe logging data >',CANoe_Logging_mat_Path);
catch err
    % File path select from ui window
    [file,path] = uigetfile('*.mat','< Load the CANoe logging data >');
end

% if file was not selected from UI window, the program is terminated
if( (file == 0))
    warning('File was not selected! The program is terminated');
    return;
end

% Set the path
CANoe_Logging_mat_Path = [path,file];
save('PrevLoggingCANoePath','CANoe_Logging_mat_Path')
CANoe_GPSDataFrames = Fn_CANoeGPSDataParsing(CANoe_Logging_mat_Path);
if sum(CANoe_GPSDataFrames.IsValid)/length(CANoe_GPSDataFrames.IsValid) < 0.8
    warning('Target GPS is not RTK');
    return; 
end
fprintf(['  - [Info] Brain data time: ', num2str(CANoe_GPSDataFrames.Hour(1)+9),':',...
    num2str(CANoe_GPSDataFrames.Minute(1)),':',...
    num2str(CANoe_GPSDataFrames.Second(1)), ...
    ' ~ ',num2str(CANoe_GPSDataFrames.Hour(end)+9),':',...
    num2str(CANoe_GPSDataFrames.Minute(end)),':',...
    num2str(CANoe_GPSDataFrames.Second(end)),'\n']);
%% [Step 2] Synchronization
%%   2.1. Brain time synchronization
%     2.1.1 Brain time interpolation

% Brain Time & UTC Time
TimeSync_Base = BrainFlexRayFrames.Time;

tmp_TimeSync_Base_UTC = BrainFlexRayFrames.FrMsgOEM6_Time.OEM6_UTC_Hour*3600 + BrainFlexRayFrames.FrMsgOEM6_Time.OEM6_UTC_Minuite*60 ...
    +BrainFlexRayFrames.FrMsgOEM6_Time.OEM6_UTC_Second + BrainFlexRayFrames.FrMsgOEM6_Time.OEM6_UTC_Centisecond/100;

TimeSync_Base_UTC = tmp_TimeSync_Base_UTC;
for nIndex = 2:length(tmp_TimeSync_Base_UTC)
    if (tmp_TimeSync_Base_UTC(nIndex) ~= tmp_TimeSync_Base_UTC(nIndex -1)) || (tmp_TimeSync_Base_UTC(nIndex) < TimeSync_Base_UTC(nIndex-1))
        TimeSync_Base_UTC(nIndex) = TimeSync_Base_UTC(nIndex-1) + (TimeSync_Base(nIndex) - TimeSync_Base(nIndex -1));
    end
end
TS_BrainTime_UTCTime = timeseries(TimeSync_Base_UTC, TimeSync_Base);
TS_FlexRay_Idx_UTC = timeseries(1:length(TimeSync_Base),TimeSync_Base_UTC);
UTC_Start_List = TS_BrainTime_UTCTime.Data(1);
UTC_End_List = TS_BrainTime_UTCTime.Data(end);

% Delphi data index
tmp_UTC = resample(TS_BrainTime_UTCTime, Delphi_DataFrames.Time,'zoh');
tmp_UTC_filtered = tmp_UTC.Data(~isnan(tmp_UTC.Data));
tmp_Idx = 1:length(Delphi_DataFrames.Time);
TS_Delphi_Idx_UTC = timeseries(tmp_Idx(~isnan(tmp_UTC.Data)),tmp_UTC_filtered);
UTC_Start_List(length(UTC_Start_List)+1) = TS_Delphi_Idx_UTC.Time(1);
UTC_End_List(length(UTC_End_List)+1) = TS_Delphi_Idx_UTC.Time(end);

% Mobileye data index
tmp_UTC = resample(TS_BrainTime_UTCTime, Mobileye_DataFrames.Time,'zoh');
tmp_UTC_filtered = tmp_UTC.Data(~isnan(tmp_UTC.Data));
tmp_Idx = 1:length(Mobileye_DataFrames.Time);
TS_Mobileye_Idx_UTC = timeseries(tmp_Idx(~isnan(tmp_UTC.Data)),tmp_UTC_filtered);
UTC_Start_List(length(UTC_Start_List)+1) = TS_Mobileye_Idx_UTC.Time(1);
UTC_End_List(length(UTC_End_List)+1) = TS_Mobileye_Idx_UTC.Time(end);

% Fusionbox data index
tmp_UTC = resample(TS_BrainTime_UTCTime, FusionBox_DataFrames.Time,'zoh');
tmp_UTC_filtered = tmp_UTC.Data(~isnan(tmp_UTC.Data));
tmp_Idx = 1:length(FusionBox_DataFrames.Time);
TS_FusionBox_Idx_UTC = timeseries(tmp_Idx(~isnan(tmp_UTC.Data)),tmp_UTC_filtered);
UTC_Start_List(length(UTC_Start_List)+1) = TS_FusionBox_Idx_UTC.Time(1);
UTC_End_List(length(UTC_End_List)+1) = TS_FusionBox_Idx_UTC.Time(end);

% CANoe
TS_TargetCANoe_Idx_UTC = timeseries(1:length(CANoe_GPSDataFrames.Time),CANoe_GPSDataFrames.UTCtime);
UTC_Start_List(length(UTC_Start_List)+1) = TS_TargetCANoe_Idx_UTC.Time(1);
UTC_End_List(length(UTC_End_List)+1) = TS_TargetCANoe_Idx_UTC.Time(end);

% Resampling
ResampledTime_UTC = max(UTC_Start_List):dResamplingInterval:min(UTC_End_List);
if isempty(ResampledTime_UTC)
    warning('Files are not matched!');
    return;
end

TS_FlexRay_Idx_Resampled = resample(TS_FlexRay_Idx_UTC, ResampledTime_UTC, 'zoh');
TS_Delphi_Idx_Resampled = resample(TS_Delphi_Idx_UTC, ResampledTime_UTC, 'zoh');
TS_Mobileye_Idx_Resampled = resample(TS_Mobileye_Idx_UTC, ResampledTime_UTC, 'zoh');
TS_FusionBox_Idx_Resampled = resample(TS_FusionBox_Idx_UTC, ResampledTime_UTC, 'zoh');
TS_TargetCANoe_Idx_Resampled = resample(TS_TargetCANoe_Idx_UTC, ResampledTime_UTC, 'zoh');

Idx.FlexRay = TS_FlexRay_Idx_Resampled.Data;
Idx.Delphi = TS_Delphi_Idx_Resampled.Data;
Idx.Mobileye = TS_Mobileye_Idx_Resampled.Data;
Idx.FusionBox = TS_FusionBox_Idx_Resampled.Data;
Idx.TargetCANoe = TS_TargetCANoe_Idx_Resampled.Data;
%% [Step 3] Error estimation
%%   3.1. Reference data generation
% Parameter configuration
EgoPosLat = BrainFlexRayFrames.FrMsgOEM6_State_Latitude.OEM6_State_Latitude(Idx.FlexRay);
EgoPosLon = BrainFlexRayFrames.FrMsgOEM6_State_Longitude.OEM6_State_Longitude(Idx.FlexRay);
EgoEnu = FnFast_llh2enu(CANoe_GPSDataFrames.ref(1), CANoe_GPSDataFrames.ref(2), EgoPosLat, EgoPosLon);
EgoVel = BrainFlexRayFrames.FrMsgOEM6_State_AccVel.OEM6_State_Vxy(Idx.FlexRay);
EgoAcc = BrainFlexRayFrames.FrMsgOEM6_State_AccVel.OEM6_State_a_xy(Idx.FlexRay);
EgoHeading = BrainFlexRayFrames.FrMsgOEM6_State_SlopeHeading.OEM6_State_Heading(Idx.FlexRay);

TargetTime = CANoe_GPSDataFrames.Time(Idx.TargetCANoe);
TargetPosLat = CANoe_GPSDataFrames.Lat(Idx.TargetCANoe);
TargetPosLon = CANoe_GPSDataFrames.Lon(Idx.TargetCANoe);
TargetEnu = CANoe_GPSDataFrames.enu(Idx.TargetCANoe,:) - EgoEnu;
EgoEnu = 0*EgoEnu;
TargetVel = CANoe_GPSDataFrames.Vel(Idx.TargetCANoe);
TargetAcc = CANoe_GPSDataFrames.Acc(Idx.TargetCANoe);
TargetHeading = CANoe_GPSDataFrames.Heading(Idx.TargetCANoe);
TargetGPSValid = CANoe_GPSDataFrames.IsValid(Idx.TargetCANoe);


EastErr = nan(length(Idx.FlexRay),1);
NorthErr = nan(length(Idx.FlexRay),1);
Pos_Long = nan(length(Idx.FlexRay),1);
Pos_Lat = nan(length(Idx.FlexRay),1);
Vx_mps = nan(length(Idx.FlexRay),1);
Vy_mps = nan(length(Idx.FlexRay),1);
HeadingDiff = nan(length(Idx.FlexRay),1);
TargetPosX = nan(length(Idx.FlexRay),1);
TargetPosY = nan(length(Idx.FlexRay),1);
TargetVelX = nan(length(Idx.FlexRay),1);
TargetVelY = nan(length(Idx.FlexRay),1);
TargetAccX = nan(length(Idx.FlexRay),1);
TargetAccY = nan(length(Idx.FlexRay),1);

% Reference Time is FlexRay time
for Erridx = 1 : 1: length(Idx.FlexRay)
    Idx_CANoe_TS = Idx.TargetCANoe(Erridx);
    Idx_FlexRay_TS = Idx.FlexRay(Erridx);
    
    if TargetGPSValid == 1
        % Reference targe tvehicle position estimation
        RotMat = [cosd(-EgoHeading(Erridx)) -sind(-EgoHeading(Erridx));
            sind(-EgoHeading(Erridx)) cosd(-EgoHeading(Erridx))];

        tmp_CurrentPos = [TargetEnu(Erridx, 1) TargetEnu(Erridx, 2)]';
        tmp_CurrentPos_VehCoord = RotMat*tmp_CurrentPos;

        % Distance difference between ego and target vehicle
        EastErr(Erridx, 1) = (TargetEnu(Erridx, 1)) - EgoEnu(1);
        NorthErr(Erridx, 1) = (TargetEnu(Erridx, 2)) - EgoEnu(2) ;

        % Heading difference between ego and target vehicle
        HeadingDiff(Erridx, 1) = TargetHeading(Erridx, 1) - EgoHeading(1); % [deg]

        % Target vehicle position respect to ego vehicle coordinate
        TargetPosX(Erridx, 1) = tmp_CurrentPos_VehCoord(1);
        TargetPosY(Erridx, 1) = tmp_CurrentPos_VehCoord(2);

        % Calculating the Vx and Vy
        TargetVelX(Erridx, 1) = (TargetVel(Erridx, 1) - EgoVel(1)) * cosd(HeadingDiff(Erridx, 1));
        TargetVelY(Erridx, 1) = (TargetVel(Erridx, 1) - EgoVel(1)) * sind(HeadingDiff(Erridx, 1));

        % Calculating the ax and ay
        TargetAccX(Erridx, 1) = (TargetAcc(Erridx, 1) - EgoAcc(1)) * cosd(HeadingDiff(Erridx, 1));
        TargetAccY(Erridx, 1) = (TargetAcc(Erridx, 1) - EgoAcc(1)) * sind(HeadingDiff(Erridx, 1));
    end
end

% Save reference data
Target_RefData.Time = TargetTime;
Target_RefData.EastErr = EastErr;
Target_RefData.NorthErr = NorthErr;
Target_RefData.PosX = TargetPosX;
Target_RefData.PosY = TargetPosY;
Target_RefData.VelX = TargetVelX;
Target_RefData.VelY = TargetVelY;
Target_RefData.AccX = TargetAccX;
Target_RefData.AccY = TargetAccY;
Target_RefData.Heading = HeadingDiff;
Target_RefData.ObjectFlag.Delphi = false(length(Target_RefData.PosX),1);
Target_RefData.ObjectFlag.Mobileye = false(length(Target_RefData.PosX),1);
Target_RefData.ObjectFlag.FusionBox = false(length(Target_RefData.PosX),1);

% % Plotting
% figure(1);
% plot(TargetEnu(:,1), TargetEnu(:,2),'.','LineWidth',2); hold on; grid on; axis equal;
% plot(EgoEnu(1),EgoEnu(2),'p', 'MarkerSize', 10);hold off;
% figure(2);
% plot(EastErr(:,1), NorthErr(:,1),'.','LineWidth',2); grid on; hold on; axis equal;
% plot(0,0,'p', 'MarkerSize', 10);hold off;
% 
% figure(3)
% plot(TargetPosY(:, 1), TargetPosX(:, 1), '.', 'MarkerSize', 3); grid on; hold on; axis equal;
% plot(EgoEnu(1),EgoEnu(2),'p', 'MarkerSize', 10);hold off;
% 
% figure (4)
% plot(TargetVelX(:, 1), TargetVelY(:, 1), '.', 'MarkerSize', 3); grid on; axis equal;
%%   3.2. Error estimation
DelphiObj_Time = Delphi_DataFrames.Time;
DelphiObj_ID = Delphi_DataFrames.DynObjList.nID;
DelphiObj_Age = Delphi_DataFrames.DynObjList.nAge;
DelphiObj_PosX = Delphi_DataFrames.DynObjList.X_m + Delphi_offsetX;
DelphiObj_PosY = Delphi_DataFrames.DynObjList.Y_m;
DelphiObj_Vx = Delphi_DataFrames.DynObjList.Vx_mps;
DelphiObj_Vy = Delphi_DataFrames.DynObjList.Vy_mps;
DelphiObj_AccX = Delphi_DataFrames.DynObjList.AccX;
DelphiObj_Heading = Delphi_DataFrames.DynObjList.Yaw_deg;
DelphiObj_Width = Delphi_DataFrames.DynObjList.Width_m;

MobileyeObj_Time = Mobileye_DataFrames.Time;
MobileyeObj_ID = Mobileye_DataFrames.DynObjList.nID;
MobileyeObj_Age = Mobileye_DataFrames.DynObjList.nAge;
MobileyeObj_Type = Mobileye_DataFrames.DynObjList.Type;
MobileyeObj_Valid = Mobileye_DataFrames.DynObjList.Valid;
MobileyeObj_PosX = Mobileye_DataFrames.DynObjList.X_m + Mobileye_offsetX;
MobileyeObj_PosY = Mobileye_DataFrames.DynObjList.Y_m;
MobileyeObj_Vx = Mobileye_DataFrames.DynObjList.Vx_mps;
MobileyeObj_Heading = Mobileye_DataFrames.DynObjList.Yaw_deg;
MobileyeObj_Width = Mobileye_DataFrames.DynObjList.Width_m;
MobileyeObj_Length = Mobileye_DataFrames.DynObjList.Length_m;

FusionBoxObj_Time = FusionBox_DataFrames.Time;
FusionBoxObj_ID = FusionBox_DataFrames.DynObj.nID;
FusionBoxObj_Age = FusionBox_DataFrames.DynObj.nAge;
FusionBoxObj_PosX = FusionBox_DataFrames.DynObj.X_m;
FusionBoxObj_PosY = FusionBox_DataFrames.DynObj.Y_m;
FusionBoxObj_Vx = FusionBox_DataFrames.DynObj.Vx_mps;
FusionBoxObj_Vy = FusionBox_DataFrames.DynObj.Vy_mps;
FusionBoxObj_Heading = FusionBox_DataFrames.DynObj.Yaw_deg;
FusionBoxObj_Width = FusionBox_DataFrames.DynObj.Width_m;
FusionBoxObj_Length = FusionBox_DataFrames.DynObj.Length_m;

ValidDelphiID.ID = 0;
ValidDelphiID.Prob = 0;
ValidMobileyeID.ID = 0;
ValidMobileyeID.Prob = 0;
ValidFusionBoxID.ID = 0;
ValidFusionBoxID.Prob = 0;

Delphi_HeadingErr = 0;
Mobileye_HeadingErr = 0;
FusionBox_HeadingErr = 0;

tmp_DelphiErrList = cell(0);
tmp_MobileyeErrList = cell(0);
tmp_FusionBoxErrList = cell(0);

% Erroe estimation with each sensors
fprintf('  - Estimating errors...     ');
for ErrIdx = 1 : 1 : length(Idx.FlexRay)
    Idx_FlexRay_TS = Idx.FlexRay(ErrIdx);
    Delphi_TS = Idx.Delphi(ErrIdx);
    Mobileye_TS = Idx.Mobileye(ErrIdx);
    FusionBox_TS = Idx.FusionBox(ErrIdx);
    
    % Delphi Error estimation
    tmp_Delphi_Position_List = sqrt(((DelphiObj_PosX(Delphi_TS, :) - Target_RefData.PosX(ErrIdx)).^2)+((DelphiObj_PosY(Delphi_TS, :) - Target_RefData.PosY(ErrIdx)).^2));
    idx_DelphiObj = find(tmp_Delphi_Position_List < dValidationGate);
    nDelphiObj = 0;
    if idx_DelphiObj ~= 0
        nDelphiObj = length(idx_DelphiObj);
        
        tmp_DistList = (DelphiObj_PosX(Delphi_TS, idx_DelphiObj) - Target_RefData.PosX(ErrIdx)).^2 + (DelphiObj_PosY(Delphi_TS, idx_DelphiObj) - Target_RefData.PosY(ErrIdx)).^2;
        ValidDelphiID = Fn_IdTracker(DelphiObj_ID(Delphi_TS, idx_DelphiObj), tmp_DistList, ValidDelphiID);
        if ~isnan(ValidDelphiID.ID)
            Idx_Mask = DelphiObj_ID(Delphi_TS,:) == ValidDelphiID.ID;
            
            Target_RefData.ObjectFlag.Delphi(ErrIdx) = true;
            
            tmp_DelphiErrList.bTrackValid(ErrIdx, 1) = true;
            tmp_DelphiErrList.Time(ErrIdx, 1) = DelphiObj_Time(Delphi_TS);
            tmp_DelphiErrList.NumofObj(ErrIdx, 1) = nDelphiObj;
            tmp_DelphiErrList.nID(ErrIdx, 1) = DelphiObj_ID(Delphi_TS, Idx_Mask);
            tmp_DelphiErrList.nAge(ErrIdx, 1) = DelphiObj_Age(Delphi_TS, Idx_Mask);
            tmp_DelphiErrList.PosX(ErrIdx, 1) = DelphiObj_PosX(Delphi_TS, Idx_Mask) - Target_RefData.PosX(ErrIdx);
            tmp_DelphiErrList.PosY(ErrIdx, 1) = DelphiObj_PosY(Delphi_TS, Idx_Mask) - Target_RefData.PosY(ErrIdx);
            tmp_DelphiErrList.Vx(ErrIdx, 1) = DelphiObj_Vx(Delphi_TS, Idx_Mask) - Target_RefData.VelX(ErrIdx);
            tmp_DelphiErrList.Vy(ErrIdx, 1) = DelphiObj_Vy(Delphi_TS, Idx_Mask) - Target_RefData.VelY(ErrIdx);
            tmp_DelphiErrList.AccX(ErrIdx, 1) = DelphiObj_AccX(Delphi_TS, Idx_Mask) - Target_RefData.AccX(ErrIdx);
            
            Delphi_HeadingErr = DelphiObj_Heading(Delphi_TS, Idx_Mask) - Target_RefData.Heading(ErrIdx);            
            if Delphi_HeadingErr >= 180
               Delphi_HeadingErr =  Delphi_HeadingErr - 360;
            end
            tmp_DelphiErrList.Heading(ErrIdx, 1) = Delphi_HeadingErr;
            
            tmp_DelphiErrList.Width(ErrIdx, 1) = DelphiObj_Width(Delphi_TS, Idx_Mask);
            
            tmp_DelphiErrList.ref.Time(ErrIdx, 1) = DelphiObj_Time(Delphi_TS);
            tmp_DelphiErrList.ref.NumofObj = nDelphiObj;
            tmp_DelphiErrList.ref.nID(ErrIdx, 1) = DelphiObj_ID(Delphi_TS, Idx_Mask);
            tmp_DelphiErrList.ref.nAge(ErrIdx, 1) = DelphiObj_Age(Delphi_TS, Idx_Mask);
            tmp_DelphiErrList.ref.PosX(ErrIdx, 1) = DelphiObj_PosX(Delphi_TS, Idx_Mask);
            tmp_DelphiErrList.ref.PosY(ErrIdx, 1) = DelphiObj_PosY(Delphi_TS, Idx_Mask);
            tmp_DelphiErrList.ref.Vx(ErrIdx, 1) = DelphiObj_Vx(Delphi_TS, Idx_Mask);
            tmp_DelphiErrList.ref.Vy(ErrIdx, 1) = DelphiObj_Vy(Delphi_TS, Idx_Mask);
            tmp_DelphiErrList.ref.AccX(ErrIdx, 1) = DelphiObj_AccX(Delphi_TS, Idx_Mask);                     
            tmp_DelphiErrList.ref.Heading(ErrIdx, 1) = DelphiObj_Heading(Delphi_TS, Idx_Mask);            
            tmp_DelphiErrList.ref.Width(ErrIdx, 1) = DelphiObj_Width(Delphi_TS, Idx_Mask);
        end
    end
    
    % Mobileye Error estimation
    tmp_Mobileye_Position_List = sqrt(((MobileyeObj_PosX(Mobileye_TS, :) - Target_RefData.PosX(ErrIdx)).^2)+((MobileyeObj_PosY(Mobileye_TS, :) - Target_RefData.PosY(ErrIdx)).^2));
    idx_MobileyeObj = find(tmp_Mobileye_Position_List < dValidationGate);
    
    nMobileyeObj = 0;
    
    if idx_MobileyeObj ~= 0
        nMobileyeObj = length(idx_MobileyeObj);
        
        tmp_DistList = (MobileyeObj_PosX(Mobileye_TS, idx_MobileyeObj) - Target_RefData.PosX(ErrIdx)).^2 + (MobileyeObj_PosY(Mobileye_TS, idx_MobileyeObj) - Target_RefData.PosY(ErrIdx)).^2;
        ValidMobileyeID = Fn_IdTracker(MobileyeObj_ID(Mobileye_TS, idx_MobileyeObj), tmp_DistList, ValidMobileyeID);
        if ~isnan(ValidMobileyeID.ID)
            Idx_Mask = MobileyeObj_ID(Mobileye_TS,:) == ValidMobileyeID.ID;
            
            Target_RefData.ObjectFlag.Mobileye(ErrIdx) = true;
            
            tmp_MobileyeErrList.bTrackValid(ErrIdx, 1) = true;
            tmp_MobileyeErrList.Time(ErrIdx, 1) = MobileyeObj_Time(Mobileye_TS);
            tmp_MobileyeErrList.NumofObj(ErrIdx, 1) = nMobileyeObj;
            tmp_MobileyeErrList.nID(ErrIdx, 1) = MobileyeObj_ID(Mobileye_TS, Idx_Mask);
            tmp_MobileyeErrList.nAge(ErrIdx, 1) = MobileyeObj_Age(Mobileye_TS, Idx_Mask);
            tmp_MobileyeErrList.nType(ErrIdx, 1) = MobileyeObj_Type(Mobileye_TS, Idx_Mask);
            tmp_MobileyeErrList.Valid(ErrIdx, 1) = MobileyeObj_Valid(Mobileye_TS, Idx_Mask);
            tmp_MobileyeErrList.PosX(ErrIdx, 1) = MobileyeObj_PosX(Mobileye_TS, Idx_Mask) - Target_RefData.PosX(ErrIdx);
            tmp_MobileyeErrList.PosY(ErrIdx, 1) = MobileyeObj_PosY(Mobileye_TS, Idx_Mask) - Target_RefData.PosY(ErrIdx);
            tmp_MobileyeErrList.Vx(ErrIdx, 1) = MobileyeObj_Vx(Mobileye_TS, Idx_Mask) - Target_RefData.VelX(ErrIdx);
            
            Mobileye_HeadingErr = MobileyeObj_Heading(Mobileye_TS, Idx_Mask) - Target_RefData.Heading(ErrIdx);
            if Mobileye_HeadingErr >= 180
               Mobileye_HeadingErr =  Mobileye_HeadingErr - 360;
            end                     
            tmp_MobileyeErrList.Heading(ErrIdx, 1) = Mobileye_HeadingErr;
            
            tmp_MobileyeErrList.Width(ErrIdx, 1) = MobileyeObj_Width(Mobileye_TS, Idx_Mask);
            tmp_MobileyeErrList.Length(ErrIdx, 1) = MobileyeObj_Length(Mobileye_TS, Idx_Mask);
            
            tmp_MobileyeErrList.ref.Time(ErrIdx, 1) = MobileyeObj_Time(Mobileye_TS);
            tmp_MobileyeErrList.ref.nID(ErrIdx, 1) = MobileyeObj_ID(Mobileye_TS, Idx_Mask);
            tmp_MobileyeErrList.ref.nAge(ErrIdx, 1) = MobileyeObj_Age(Mobileye_TS, Idx_Mask);
            tmp_MobileyeErrList.ref.nType(ErrIdx, 1) = MobileyeObj_Type(Mobileye_TS, Idx_Mask);
            tmp_MobileyeErrList.ref.Valid(ErrIdx, 1) = MobileyeObj_Valid(Mobileye_TS, Idx_Mask);
            tmp_MobileyeErrList.ref.PosX(ErrIdx, 1) = MobileyeObj_PosX(Mobileye_TS, Idx_Mask);
            tmp_MobileyeErrList.ref.PosY(ErrIdx, 1) = MobileyeObj_PosY(Mobileye_TS, Idx_Mask);
            tmp_MobileyeErrList.ref.Vx(ErrIdx, 1) = MobileyeObj_Vx(Mobileye_TS, Idx_Mask);            
            tmp_MobileyeErrList.ref.Heading(ErrIdx, 1) = MobileyeObj_Heading(Mobileye_TS, Idx_Mask);
            tmp_MobileyeErrList.ref.Width(ErrIdx, 1) = MobileyeObj_Width(Mobileye_TS, Idx_Mask);
            tmp_MobileyeErrList.ref.Length(ErrIdx, 1) = MobileyeObj_Length(Mobileye_TS, Idx_Mask);
        end
    end
    
    % FusionBox Error estimation
    tmp_FusionBox_Position_List = sqrt(((FusionBoxObj_PosX(FusionBox_TS, :) - Target_RefData.PosX(ErrIdx)).^2)+((FusionBoxObj_PosY(FusionBox_TS, :) - Target_RefData.PosY(ErrIdx)).^2));
    idx_FusionBoxObj = find(tmp_FusionBox_Position_List < dValidationGate);
    nFusionBoxObj = 0;
    if idx_FusionBoxObj ~=0
        nFusionBoxObj = length(idx_FusionBoxObj);
        
        tmp_DistList = (FusionBoxObj_PosX(FusionBox_TS, idx_FusionBoxObj) - Target_RefData.PosX(ErrIdx)).^2 + (FusionBoxObj_PosY(FusionBox_TS, idx_FusionBoxObj) - Target_RefData.PosY(ErrIdx)).^2;
        ValidFusionBoxID = Fn_IdTracker(FusionBoxObj_ID(FusionBox_TS, idx_FusionBoxObj), tmp_DistList, ValidFusionBoxID);
        
        if ~isnan(ValidFusionBoxID.ID)
            Idx_Mask = FusionBoxObj_ID(FusionBox_TS,:) == ValidFusionBoxID.ID;
            
            Target_RefData.ObjectFlag.FusionBox(ErrIdx) = true;
            
            tmp_FusionBoxErrList.bTrackValid(ErrIdx, 1) = true;
            tmp_FusionBoxErrList.Time(ErrIdx, 1) = FusionBoxObj_Time(FusionBox_TS);
            tmp_FusionBoxErrList.NumofObj(ErrIdx, 1) = nFusionBoxObj;
            tmp_FusionBoxErrList.nID(ErrIdx, 1) = FusionBoxObj_ID(FusionBox_TS, Idx_Mask);
            tmp_FusionBoxErrList.nAge(ErrIdx, 1) = FusionBoxObj_Age(FusionBox_TS, Idx_Mask);
            tmp_FusionBoxErrList.PosX(ErrIdx, 1) = FusionBoxObj_PosX(FusionBox_TS, Idx_Mask) - Target_RefData.PosX(ErrIdx);
            tmp_FusionBoxErrList.PosY(ErrIdx, 1) = FusionBoxObj_PosY(FusionBox_TS, Idx_Mask) - Target_RefData.PosY(ErrIdx);
            tmp_FusionBoxErrList.Vx(ErrIdx, 1) = FusionBoxObj_Vx(FusionBox_TS, Idx_Mask) - Target_RefData.VelX(ErrIdx);
            tmp_FusionBoxErrList.Vy(ErrIdx, 1) = FusionBoxObj_Vy(FusionBox_TS, Idx_Mask) - Target_RefData.VelY(ErrIdx);
            
            FusionBox_HeadingErr = FusionBoxObj_Heading(FusionBox_TS, Idx_Mask) - Target_RefData.Heading(ErrIdx);
            if FusionBox_HeadingErr >= 180
               FusionBox_HeadingErr =  FusionBox_HeadingErr - 360;
            end                     
            tmp_FusionBoxErrList.Heading(ErrIdx, 1) = FusionBox_HeadingErr;
            
            tmp_FusionBoxErrList.Width(ErrIdx, 1) = FusionBoxObj_Width(FusionBox_TS, Idx_Mask);
            tmp_FusionBoxErrList.Length(ErrIdx, 1) = FusionBoxObj_Length(FusionBox_TS, Idx_Mask);
            
            tmp_FusionBoxErrList.ref.Time(ErrIdx, 1) = FusionBoxObj_Time(FusionBox_TS);
            tmp_FusionBoxErrList.ref.nID(ErrIdx, 1) = FusionBoxObj_ID(FusionBox_TS, Idx_Mask);
            tmp_FusionBoxErrList.ref.nAge(ErrIdx, 1) = FusionBoxObj_Age(FusionBox_TS, Idx_Mask);
            tmp_FusionBoxErrList.ref.PosX(ErrIdx, 1) = FusionBoxObj_PosX(FusionBox_TS, Idx_Mask);
            tmp_FusionBoxErrList.ref.PosY(ErrIdx, 1) = FusionBoxObj_PosY(FusionBox_TS, Idx_Mask);
            tmp_FusionBoxErrList.ref.Vx(ErrIdx, 1) = FusionBoxObj_Vx(FusionBox_TS, Idx_Mask);
            tmp_FusionBoxErrList.ref.Vy(ErrIdx, 1) = FusionBoxObj_Vy(FusionBox_TS, Idx_Mask);
            tmp_FusionBoxErrList.ref.Heading(ErrIdx, 1) = FusionBoxObj_Heading(FusionBox_TS, Idx_Mask);
            tmp_FusionBoxErrList.ref.Width(ErrIdx, 1) = FusionBoxObj_Width(FusionBox_TS, Idx_Mask);
            tmp_FusionBoxErrList.ref.Length(ErrIdx, 1) = FusionBoxObj_Length(FusionBox_TS, Idx_Mask);
        end
    end
    
    %     if mod(ErrIdx,3) == 0
    %         figure(1);
    %         clf;
    %         axis equal; box on; grid on;
    %
    %         hold on;
    %         plot(0, 0, 'r.')
    %         plot(Target_RefData.PosY(ErrIdx), Target_RefData.PosX(ErrIdx), 'ro');
    %
    %         if nDelphiObj ~= 0; plot(tmp_DelphiErrList.ref.PosY(ErrIdx, 1:nDelphiObj), tmp_DelphiErrList.ref.PosX(ErrIdx, 1:nDelphiObj), 'bx'); end
    %         if nMobileyeObj ~= 0; plot(tmp_MobileyeErrList.ref.PosY(ErrIdx, 1:nMobileyeObj), tmp_MobileyeErrList.ref.PosX(ErrIdx, 1:nMobileyeObj), 'g^'); end
    %         if nFusionBoxObj ~= 0; plot(tmp_FusionBoxErrList.ref.PosY(ErrIdx, 1:nFusionBoxObj), tmp_FusionBoxErrList.ref.PosX(ErrIdx, 1:nFusionBoxObj), 'm*'); end
    %
    %         hold off;
    %
    %         pause(0.01);
    %     end
    %     figure(2);
    %     subplot(211)
    %     hold on;
    %     plot(ErrIdx, ValidDelphiID.ID, 'b.');
    %     plot(ErrIdx, ValidMobileyeID.ID, 'g.');
    %     plot(ErrIdx, ValidFusionBoxID.ID, 'm.');
    %     hold off;
    %
    %     subplot(212)
    %     hold on;
    %     plot(ErrIdx, ValidDelphiID.Prob, 'b.');
    %     plot(ErrIdx, ValidMobileyeID.Prob, 'g.');
    %     plot(ErrIdx, ValidFusionBoxID.Prob, 'm.');
    %     hold off;
    %
    fprintf('\b\b\b\b\b\b %3.f %%',ErrIdx*100/length(Idx.FlexRay));
end

aSensorErrList.Delphi = tmp_DelphiErrList;
aSensorErrList.Mobileye = tmp_MobileyeErrList;
aSensorErrList.FusionBox = tmp_FusionBoxErrList;
aSensorErrList.Reference = Target_RefData;
%% [Step 4] Data export
tmp_Filename = strsplit(File_path,'\');
Filename = strcat(tmp_Filename(end), '.mat');
% destination = fullfile(tmp_Filename(1), );
destination = 'E:\02_Project\03_HAD\01_DB\[170424]_[MIDAN]_[SENSOR]\DataAnalysis\';
saveFile = fullfile(destination, Filename);
save(saveFile{1}, 'aSensorErrList');
fprintf('  - Data export Complete  \n');

