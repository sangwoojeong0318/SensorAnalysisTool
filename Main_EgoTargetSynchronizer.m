%%  File Name: Main_BrainFlexRayAnalysis.m
%  Description: Brain FlexRay data parsing
%  Copyright(C) 2014 ACE Lab, All Right Reserved.
% *************************************************************************
clc; clear all; close all;

%% 00. Configuration
db_mat_Path = 'DB\AutonomousFlexRay_DB.mat';
Cfg_GPS_Plot_on = 1;
Cfg_IVS_Plot_on = 1;
Cfg_TRANS_Plot_on = 1;
Cfg_Autonomous_Plot_on = 1;

%% 01. Load the logging data
% 1.1 Load A1 GPS (FlexRay)
% Previous path load
try
    % load the previous path *.mat file
    load PreviousPathTarget;
    % File path select from ui window with previous file path
    [File_filename,File_path] = uigetfile('*.mat','< Load the in logging data >',Target_sig_path);
catch
    % File path select from ui window
    [File_filename,File_path] = uigetfile('*.mat','< Load the in logging data >');
end;

Target_sig_path = [File_path, File_filename];
save('PreviousPathTarget','Target_sig_path');
load(Target_sig_path);

% BrainLogged_FlexRayFrame_Byte = Fn_BrainFlexRayParsing(db_mat_Path, Logging_csv_path);
% BrainFlexRayFrames_Byte = BrainLogged_FlexRayFrame_Byte;
% BrainFlexRayFrames = Fn_FlexRayParsingFromByte(BrainLogged_FlexRayFrame_Byte);

% Hour = BrainFlexRayFrames.FrMsgOEM6_Time.OEM6_UTC_Hour;
% Min = BrainFlexRayFrames.FrMsgOEM6_Time.OEM6_UTC_Minuite;
% Sec = BrainFlexRayFrames.FrMsgOEM6_Time.OEM6_UTC_Second;
% CSec = BrainFlexRayFrames.FrMsgOEM6_Time.OEM6_UTC_Centisecond;

% A1_tmp.UTCTime = (Hour.*3600 + Min.*60 + Sec) .* 10 + CSec/10;
% A1_tmp.Lat = BrainFlexRayFrames.FrMsgOEM6_State_Latitude.OEM6_State_Latitude;
% A1_tmp.Lon = BrainFlexRayFrames.FrMsgOEM6_State_Longitude.OEM6_State_Longitude;
% A1_tmp.Head = BrainFlexRayFrames.FrMsgOEM6_State_SlopeHeading.OEM6_State_Heading;
% A1_tmp.GPSValid = BrainFlexRayFrames.FrMsgOEM6_Status.OEM6_GPSQuality;
% A1_tmp.Vel_kph = BrainFlexRayFrames.FrMsgOEM6_State_AccVel.OEM6_State_Vxy * 3.6;

Hour = OEM6_UTC_Hour;
Min = OEM6_UTC_Minuite;
Sec = OEM6_UTC_Second;
CSec = OEM6_UTC_Centisecond;

A1_tmp.UTCTime = (Hour.*3600 + Min.*60 + Sec) .* 10 + CSec/10;
A1_tmp.Lat = OEM6_State_Latitude;
A1_tmp.Lon = OEM6_State_Longitude;
A1_tmp.Head = OEM6_State_Heading;
A1_tmp.GPSValid = OEM6_GPSQuality;
A1_tmp.Vel_kph = OEM6_State_Vxy * 3.6;

A1.UTCTime(1) = A1_tmp.UTCTime(1);
A1.Lat(1) = A1_tmp.Lat(1);
A1.Lon(1) = A1_tmp.Lon(1);
A1.Head(1) = A1_tmp.Head(1);
A1.GPSValid(1) = A1_tmp.GPSValid(1);
A1.Vel_kph(1) = A1_tmp.Vel_kph(1);

idxA1 = 1;
for idx = 2:1:size(A1_tmp.UTCTime,1)
    if(A1_tmp.UTCTime(idx) ~= A1_tmp.UTCTime(idx-1))
        idxA1 = idxA1 + 1;
        A1.UTCTime(idxA1) = A1_tmp.UTCTime(idx);
        A1.Lat(idxA1) = A1_tmp.Lat(idx);
        A1.Lon(idxA1) = A1_tmp.Lon(idx);
        A1.Head(idxA1) = A1_tmp.Head(idx);
        A1.GPSValid(idxA1) = A1_tmp.GPSValid(idxA1);
        A1.Vel_kph(idxA1) = A1_tmp.Vel_kph(idxA1);
    end
end

% 1.2 Load zoe GPS / Stereo object
% Previous path load
try
    % load the previous path *.mat file
    load PreviousPathZoe;
    % File path select from ui window with previous file path
    [File_filename_zoe,File_path_zoe] = uigetfile('*.mat','< Load the in logging data >',Logging_mat_path);
catch
    % File path select from ui window
    [File_filename_zoe,File_path_zoe] = uigetfile('*.mat','< Load the in logging data >');
end;

Logging_mat_path = [File_path_zoe, File_filename_zoe];
save('PreviousPathZoe','Logging_mat_path');

Zoe = fnGetZoeCAN(Logging_mat_path);


%% 02. Time synchronization
nA1 = size(A1.UTCTime, 2);
nZoe = size(Zoe.UTCTime, 2);

idxZoe_start = 1;
idxRes = 0;
for idxA1 = 1:1:nA1
    for idxZoe = idxZoe_start:1:nZoe
        if(A1.UTCTime(idxA1) == Zoe.UTCTime(idxZoe))
            % A1과 Zoe 시간 일치
            idxRes = idxRes + 1;
            Result.UTCTime(idxRes) = A1.UTCTime(idxA1);
                      
            % Sensor validity
            if (Zoe.Obj.ID(1, idxZoe) == 0 && ...
                Zoe.Obj.ID(2, idxZoe) == 0 && ...
                Zoe.Obj.ID(3, idxZoe) == 0 && ...
                Zoe.Obj.ID(4, idxZoe) == 0 && ...
                Zoe.Obj.ID(5, idxZoe) == 0 && ...
                Zoe.Obj.ID(6, idxZoe) == 0 && ...
                Zoe.Obj.ID(7, idxZoe) == 0 && ...
                Zoe.Obj.ID(8, idxZoe) == 0 && ...
                Zoe.Obj.ID(9, idxZoe) == 0 && ...
                Zoe.Obj.ID(10, idxZoe) == 0 && ...
                Zoe.Obj.ID(11, idxZoe) == 0 && ...
                Zoe.Obj.ID(12, idxZoe) == 0)
                Result.Validity(idxRes) = false;
            else
                Result.Validity(idxRes) = true;
            end
            
            % Zoe position (Lat, Lon, Head, Quality)
            Result.GPS.Zoe_GPSValid(idxRes) = A1.GPSValid(idxA1);
            Result.ZoePos.Lat(idxRes) = Zoe.Lat(idxZoe);
            Result.ZoePos.Lon(idxRes) = Zoe.Lon(idxZoe);
            Result.ZoePos.Head(idxRes) = Zoe.Head(idxZoe);
            
            Ref_Lat = Zoe.Lat(10); Ref_Lon = Zoe.Lon(10);
            Lat = Zoe.Lat(idxZoe); Lon = Zoe.Lon(idxZoe); Hgt = 0;
            enu = FnFast_llh2enu(Ref_Lat,Ref_Lon,Lat,Lon,Hgt);
            Result.ZoePos.X_Glo(idxRes) = enu(1);
            Result.ZoePos.Y_Glo(idxRes) = enu(2);
            
            % Zoe status
            Result.ZoeVel_kph(idxRes) = Zoe.Vel_kph(idxZoe);
            
            % A1 position (X, Y, Lat, Lon, Heading, Quality)
            Result.GPS.A1_GPSValid(idxRes) = A1.GPSValid(idxA1);
            Result.A1Pos.Lat(idxRes) = A1.Lat(idxA1);
            Result.A1Pos.Lon(idxRes) = A1.Lon(idxA1);
            Result.A1Pos.Head(idxRes) = A1.Head(idxA1);
            
            Ref_Lat = Zoe.Lat(10); Ref_Lon = Zoe.Lon(10);
            Lat = A1.Lat(idxA1); Lon = A1.Lat(idxA1); Hgt = 0;
            enu = FnFast_llh2enu(Ref_Lat,Ref_Lon,Lat,Lon,Hgt);
            Result.A1Pos.X_Glo(idxRes) = enu(1);
            Result.A1Pos.Y_Glo(idxRes) = enu(2);
            
            Ref_Lat = Zoe.Lat(idxZoe); Ref_Lon = Zoe.Lon(idxZoe);
            Lat = A1.Lat(idxA1); Lon = A1.Lat(idxA1); Hgt = 0;
            enu = FnFast_llh2enu(Ref_Lat,Ref_Lon,Lat,Lon,Hgt);
            Result.A1Pos.RelHead(idxRes) = A1.Head(idxA1) - Zoe.Head(idxZoe);
            AbsHead = Zoe.Head(idxZoe);
            
            Rotmat = [cosd(AbsHead), sind(AbsHead);-sin(AbsHead), cosd(AbsHead)];
            locpos = Rotmat * [enu(1); enu(2)];
            
            Result.A1Pos.X_Loc(idxRes) = locpos(1);
            Result.A1Pos.Y_Loc(idxRes) = locpos(2);
            Result.A1Pos.Head_Loc(idxRes) = A1.Head(idxA1) - Zoe.Head(idxZoe);
            
            % A1 status
            Result.A1Vel_kph(idxRes) = A1.Vel_kph(idxA1);
            
            % Stereo objects
            Result.Obj.ID(:, idxRes) = Zoe.Obj.ID(:, idxZoe);
            Result.Obj.X(:, idxRes) = Zoe.Obj.X(:, idxZoe);
            Result.Obj.Y(:, idxRes) = Zoe.Obj.Y(:, idxZoe);
            Result.Obj.mid_X(:, idxRes) = Zoe.Obj.mid_X(:, idxZoe);
            Result.Obj.mid_Y(:, idxRes) = Zoe.Obj.mid_Y(:, idxZoe);
            Result.Obj.left_X(:, idxRes) = Zoe.Obj.left_X(:, idxZoe);
            Result.Obj.left_Y(:, idxRes) = Zoe.Obj.left_Y(:, idxZoe);
            Result.Obj.right_X(:, idxRes) = Zoe.Obj.right_X(:, idxZoe);
            Result.Obj.right_Y(:, idxRes) = Zoe.Obj.right_Y(:, idxZoe);
            Result.Obj.heading(:, idxRes) = Zoe.Obj.heading(:, idxZoe);
            
            % Associate stereo obj with A1
            mindist = 9999999999;
            Result.AssoObj.Valid(idxRes) = 0;
            Result.AssoObj.Time(idxRes) = 0;
            Result.AssoObj.Dist(idxRes) = 0;
            Result.AssoObj.ID(idxRes) = 0;
            Result.AssoObj.X(idxRes) = 0;
            Result.AssoObj.Y(idxRes) = 0;
            Result.AssoObj.mid_X(idxRes) = 0;
            Result.AssoObj.mid_Y(idxRes) = 0;
            Result.AssoObj.left_X(idxRes) = 0;
            Result.AssoObj.left_Y(idxRes) = 0;
            Result.AssoObj.right_X(idxRes) = 0;
            Result.AssoObj.right_Y(idxRes) = 0;
            Result.AssoObj.heading(idxRes) = 0;
            Result.AssoObj.Vel_kph(idxRes) = 0;
            Result.AssoObj.VelX_kph(idxRes) = 0;
            Result.AssoObj.VelY_kph(idxRes) = 0;
            
            for idxObj = 1:1:size(Zoe.Obj.ID,1)
                if(Result.Obj.ID(idxObj, idxRes) == 0)
                    continue
                end
                dist = sqrt((Result.A1Pos.X_Loc(idxRes) - Result.Obj.mid_X(idxObj, idxRes))^2 + ...
                    (Result.A1Pos.Y_Loc(idxRes) - Result.Obj.mid_Y(idxObj, idxRes))^2);
                if(dist < mindist)
                    mindist = dist;
                    Result.AssoObj.Valid(idxRes) = 1;
                    Result.AssoObj.Time(idxRes) = Zoe.CANTime(idxZoe);
                    
                    Result.AssoObj.Dist(idxRes) = dist;
                    Result.AssoObj.ID(idxRes) = Zoe.Obj.ID(idxObj, idxZoe);
                    Result.AssoObj.X(idxRes) = Zoe.Obj.X(idxObj, idxZoe);
                    Result.AssoObj.Y(idxRes) = Zoe.Obj.Y(idxObj, idxZoe);
                    Result.AssoObj.mid_X(idxRes) = Zoe.Obj.mid_X(idxObj, idxZoe);
                    Result.AssoObj.mid_Y(idxRes) = Zoe.Obj.mid_Y(idxObj, idxZoe);
                    Result.AssoObj.left_X(idxRes) = Zoe.Obj.left_X(idxObj, idxZoe);
                    Result.AssoObj.left_Y(idxRes) = Zoe.Obj.left_Y(idxObj, idxZoe);
                    Result.AssoObj.right_X(idxRes) = Zoe.Obj.right_X(idxObj, idxZoe);
                    Result.AssoObj.right_Y(idxRes) = Zoe.Obj.right_Y(idxObj, idxZoe);
                    Result.AssoObj.heading(idxRes) = Zoe.Obj.heading(idxObj, idxZoe);
                    Result.AssoObj.Vel_kph(idxRes) = Zoe.Obj.Vel_kph(idxObj, idxZoe);
                    Result.AssoObj.VelX_kph(idxRes) = Result.AssoObj.Vel_kph(idxRes) * cosd(Result.AssoObj.heading(idxRes));
                    Result.AssoObj.VelY_kph(idxRes) = Result.AssoObj.Vel_kph(idxRes) * sind(Result.AssoObj.heading(idxRes));
                end
            end
            idxZoe_start = idxZoe;
            break;
        end
    end
end

% figure(1);
% plot(Result.ZoePos.X_Glo, Result.ZoePos.Y_Glo, 'r.'); hold on;
% plot(Result.A1Pos.X_Glo, Result.A1Pos.Y_Glo, 'b.');
% title('Trajectory');
% axis equal;
% hold off;

% figure(2);
% for idxFrame = 1:1:max(size(Result.AssoObj.X, 1), size(Result.AssoObj.X, 2))
%     plot(Result.AssoObj.X(idxFrame), Result.AssoObj.Y(idxFrame), 'r.'); hold on;
%     plot(Result.A1Pos.X_Loc(idxFrame), Result.A1Pos.Y_Loc(idxFrame), 'b.');
%     plot(0, 0, 'x');
%     for idxFrame2 = 1:1:12
%         if(Result.Obj.ID(idxFrame2, idxFrame) ~= 0)
%             plot(Result.Obj.X(idxFrame2, idxFrame), Result.Obj.Y(idxFrame2, idxFrame), 'g.'); hold on;
%             plot([Result.Obj.left_X(idxFrame2, idxFrame), Result.Obj.mid_X(idxFrame2, idxFrame)], [Result.Obj.left_Y(idxFrame2, idxFrame), Result.Obj.mid_Y(idxFrame2, idxFrame)], 'g');
%             plot([Result.Obj.right_X(idxFrame2, idxFrame), Result.Obj.mid_X(idxFrame2, idxFrame)], [Result.Obj.right_Y(idxFrame2, idxFrame), Result.Obj.mid_Y(idxFrame2, idxFrame)], 'g');
%         end
%     end
%     plot(Result.AssoObj.X(idxFrame), Result.AssoObj.Y(idxFrame), 'r.');
%     plot([Result.AssoObj.left_X(idxFrame), Result.AssoObj.mid_X(idxFrame)], [Result.AssoObj.left_Y(idxFrame), Result.AssoObj.mid_Y(idxFrame)], 'r');
%     plot([Result.AssoObj.right_X(idxFrame), Result.AssoObj.mid_X(idxFrame)], [Result.AssoObj.right_Y(idxFrame), Result.AssoObj.mid_Y(idxFrame)], 'r');
%     title('Objects');
%     legend('Associated Obj', 'Target', 'ZOE', 'Ohter Obj');
%     xlim([-30, 30]);
%     ylim([-10, 10]);
%     axis equal;
%     grid on;
%     hold off;
%     pause(0.1);
% end

% Save reference
%%   3.1. Reference data generation
% Parameter configuration
EgoPosLat = Result.ZoePos.Lat';
EgoPosLon = Result.ZoePos.Lon';

Ref_Lat = Zoe.Lat(10); Ref_Lon = Zoe.Lon(10);
EgoEnu = FnFast_llh2enu(Ref_Lat, Ref_Lon, EgoPosLat, EgoPosLon);

EgoVel = Result.ZoeVel_kph';
% EgoAcc = BrainFlexRayFrames.FrMsgOEM6_State_AccVel.OEM6_State_a_xy(Idx.FlexRay);
EgoHeading = Result.ZoePos.Head;


TargetTime = Result.UTCTime';
TargetPosLat = Result.A1Pos.Lat';
TargetPosLon = Result.A1Pos.Lon';

tmpEnu = FnFast_llh2enu(Ref_Lat, Ref_Lon, TargetPosLat, TargetPosLon);
TargetEnu = tmpEnu - EgoEnu;
EgoEnu = 0*EgoEnu;

TargetVel = Result.A1Vel_kph';
% TargetAcc = CANoe_GPSDataFrames.Acc(Idx.TargetCANoe);
TargetHeading = Result.A1Pos.Head';
TargetGPSValid = Result.GPS.A1_GPSValid';

Idx.FlexRay = EgoPosLat';
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
    if TargetGPSValid(Erridx) == 4
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
% 
%         % Calculating the ax and ay
%         TargetAccX(Erridx, 1) = (TargetAcc(Erridx, 1) - EgoAcc(1)) * cosd(HeadingDiff(Erridx, 1));
%         TargetAccY(Erridx, 1) = (TargetAcc(Erridx, 1) - EgoAcc(1)) * sind(HeadingDiff(Erridx, 1));
    end
end

% Save reference data
Target_RefData.Time = TargetTime;
Target_RefData.EastErr = EastErr;
Target_RefData.NorthErr = NorthErr;
Target_RefData.PosX = TargetPosX;
Target_RefData.PosY = TargetPosY;
Target_RefData.Vel = TargetVel;
Target_RefData.VelX = TargetVelX;
b.VelY = TargetVelY;
Target_RefData.AccX = TargetAccX;
Target_RefData.AccY = TargetAccY;
Target_RefData.Heading = HeadingDiff;
Target_RefData.ObjectFlag.Delphi = false(length(Target_RefData.PosX),1);
Target_RefData.ObjectFlag.Stereo = Result.Validity;
Target_RefData.ObjectFlag.FusionBox = false(length(Target_RefData.PosX),1);

% Save stereo
tmp_StereoErrList.bTrackValid = Result.AssoObj.Valid';
tmp_StereoErrList.Time = Result.AssoObj.Time';
tmp_StereoErrList.NumofObj = Result.AssoObj.Valid';
tmp_StereoErrList.nID = Result.AssoObj.ID';
tmp_StereoErrList.Valid = Result.AssoObj.Valid';
tmp_StereoErrList.PosX = Result.AssoObj.X' - Target_RefData.PosX;
tmp_StereoErrList.PosY = Result.AssoObj.Y' - Target_RefData.PosY;
tmp_StereoErrList.V = Result.AssoObj.Vel_kph' - TargetVel;
tmp_StereoErrList.Vx = Result.AssoObj.VelX_kph' - Target_RefData.VelX;
tmp_StereoErrList.Vy = Result.AssoObj.VelY_kph' - Target_RefData.VelY;
tmp_StereoErrList.Width = Result.AssoObj.Valid';
tmp_StereoErrList.Length = Result.AssoObj.Valid';

for idx = 1:1:size(Result.AssoObj.heading,2)
    HeadingErr = Result.AssoObj.heading(idx);
    if HeadingErr >= 180
       HeadingErr =  HeadingErr - 360;
    end        
    tmp_StereoErrList.Heading(idx, 1) = HeadingErr';
end

tmp_StereoErrList.ref.Time = Result.AssoObj.Time';
tmp_StereoErrList.ref.nID = Result.AssoObj.ID';
tmp_StereoErrList.ref.Valid = Result.AssoObj.Valid';
tmp_StereoErrList.ref.PosX = Result.AssoObj.X';
tmp_StereoErrList.ref.PosY = Result.AssoObj.Y';
tmp_StereoErrList.ref.V = Result.AssoObj.Vel_kph';
tmp_StereoErrList.ref.Vx = Result.AssoObj.VelX_kph';
tmp_StereoErrList.ref.Vy = Result.AssoObj.VelY_kph';
tmp_StereoErrList.ref.Heading = Result.AssoObj.heading';
tmp_StereoErrList.ref.Width = Result.AssoObj.Valid';
tmp_StereoErrList.ref.Length = Result.AssoObj.Valid';


aSensorErrList.Stereo = tmp_StereoErrList;
aSensorErrList.Reference = Target_RefData;

%% Save data
% Synched signals
tmp_Filename = strsplit(File_path,'\');
Filename = 'SynchedSignals.mat';
destination = File_path_zoe;
saveFile = fullfile(destination, Filename);
save(saveFile, 'aSensorErrList');

% Target signals
TargetFlexRayFrames.Lat = OEM6_State_Latitude;
TargetFlexRayFrames.Lon = OEM6_State_Longitude;
TargetFlexRayFrames.Head = OEM6_State_Heading;
Filename = 'BrainFlexrayParsing.mat';
destination = File_path_zoe;
saveFile = fullfile(destination, Filename);
save(saveFile, 'TargetFlexRayFrames');
%%
% %% 02. Plot setting
% %% 02.1 Plot Configuration
% Plot_ColorTable
% scrsz = get(0,'ScreenSize');    % ScreenSize is a four-element vector: [left, bottom, width, height]
% PlotArrSize = [4 4]; % Plot arrange size
% %% 02.2 GPS Plot
% if Cfg_GPS_Plot_on == 1
%     %% GPS llh
%     Row = 1;
%     Column = 1;
%     figure('NumberTitle','off','Name','GPS llh','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     scrsz(4)/PlotArrSize(2)*(PlotArrSize(2)-Row) ...
%         scrsz(3)/PlotArrSize(1)                scrsz(4)/PlotArrSize(2) ]           );  % [left, bottom, width, height]
%     hold on;
%     plot(BrainFlexRayFrames.FrMsgOEM6_State_Longitude.OEM6_State_Longitude,BrainFlexRayFrames.FrMsgOEM6_State_Latitude.OEM6_State_Latitude...
%         ,'.-','color',PlotColorCode(1,:));
%     plot(BrainFlexRayFrames.FrMsgUbloxEVK6T_State_Longitude.UbloxEVK6T_State_Longitude,BrainFlexRayFrames.FrMsgUbloxEVK6T_State_Latitude.UbloxEVK6T_State_Latitude...
%         ,'.-','color',PlotColorCode(3,:));
%     plot(BrainFlexRayFrames.FrMsgOEM6_Longitude.OEM6_Longitude,BrainFlexRayFrames.FrMsgOEM6_Latitude.OEM6_Latitude...
%         ,'.','color',PlotColorCode(5,:));
%     plot(BrainFlexRayFrames.FrMsgUbloxEVK6T_Longitude.UbloxEVK6T_Longitude,BrainFlexRayFrames.FrMsgGarminHVS19x_Latitude.GarminHVS19x_Latitude...
%         ,'.','color',PlotColorCode(7,:));
%     hold off; grid on; box on;
%     xlabel('time [sec]'); ylabel('Heading [deg]');
%     legend('State OEM6',...
%         'State Ublox',...
%         'Meas OEM6',...
%         'Meas Ublox');
%     axis equal;
%     %% GPS Heading , slope, speed
%     Row = 1;
%     Column = 2;
%     figure('NumberTitle','off','Name','HEading&Slope&Speed','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     scrsz(4)/PlotArrSize(2)*(PlotArrSize(2)-Row) ...
%         scrsz(3)/PlotArrSize(1)                scrsz(4)/PlotArrSize(2) ]           );  % [left, bottom, width, height]
%     
%     subplot(311)
%     hold on;
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgOEM6_State_SlopeHeading.OEM6_State_Heading...
%         ,'.-','color',PlotColorCode(1,:));
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgUbloxEVK6T_State_SlpHd.UbloxEVK6T_State_Heading...
%         ,'.-','color',PlotColorCode(3,:));
%     plot(BrainFlexRayFrames.Time,mod(BrainFlexRayFrames.FrMsgOEM6_Heading.OEM6_Heading,360)...
%         ,'.','color',PlotColorCode(5,:));
%     plot(BrainFlexRayFrames.Time,mod(BrainFlexRayFrames.FrMsgUbloxEVK6T_Heading.UbloxEVK6T_Heading,360)...
%         ,'.','color',PlotColorCode(7,:));
%     hold off; grid on; box on;
%     xlabel('time [sec]'); ylabel('Heading [deg]');
%     legend('State OEM6',...
%         'State Ublox',...
%         'Meas OEM6',...
%         'Meas Ublox');
%     
%     subplot(312)
%     hold on;
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgOEM6_State_SlopeHeading.OEM6_State_Slope...
%         ,'.-','color',PlotColorCode(1,:));
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgUbloxEVK6T_State_SlpHd.UbloxEVK6T_State_Slope...
%         ,'.-','color',PlotColorCode(3,:));
%     hold off; grid on; box on;
%     xlabel('time [sec]'); ylabel('Slope [deg]');
%     legend('State OEM6',...
%         'State Ublox');
%     
%     subplot(313)
%     hold on;
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgOEM6_State_AccVel.OEM6_State_Vxy...
%         ,'.-','color',PlotColorCode(1,:));
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgUbloxEVK6T_State_AccVel.UbloxEVK6T_State_Vxy...
%         ,'.-','color',PlotColorCode(3,:));
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgOEM6_Speed.OEM6_HorSpeed...
%         ,'.','color',PlotColorCode(5,:));
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgUbloxEVK6T_Speed.UbloxEVK6T_HorSpeed...
%         ,'.','color',PlotColorCode(7,:));
%     hold off; grid on; box on;
%     xlabel('time [sec]'); ylabel('Speed [m/s]');
%     legend('State OEM6',...
%         'State Ublox',...
%         'Meas OEM6',...
%         'Meas Ublox');
%     %% GPS Type, Satellite, HDOP
%     Row = 1;
%     Column = 3;
%     figure('NumberTitle','off','Name','GPS status','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     scrsz(4)/PlotArrSize(2)*(PlotArrSize(2)-Row) ...
%         scrsz(3)/PlotArrSize(1)                scrsz(4)/PlotArrSize(2) ]           );  % [left, bottom, width, height]
%     
%     subplot(311)
%     hold on;
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgOEM6_Status.OEM6_GPSQuality...
%         ,'.','color',PlotColorCode(5,:));
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgUbloxEVK6T_Status.UbloxEVK6T_GPSQuality...
%         ,'.','color',PlotColorCode(7,:));
%     hold off; grid on; box on;
%     xlabel('time [sec]'); ylabel('Quality []');
%     legend('Meas OEM6',...
%         'Meas Ublox');
%     
%     subplot(312)
%     hold on;
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgOEM6_Status.OEM6_NumOfSat...
%         ,'.','color',PlotColorCode(5,:));
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgUbloxEVK6T_Status.UbloxEVK6T_NumOfSat...
%         ,'.','color',PlotColorCode(7,:));
%     hold off; grid on; box on;
%     xlabel('time [sec]'); ylabel('Satllite [ea]');
%     legend('Meas OEM6',...
%         'Meas Ublox');
%     
%     subplot(313)
%     hold on;
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgOEM6_Status.OEM6_HDOP...
%         ,'.','color',PlotColorCode(5,:));
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgUbloxEVK6T_Status.UbloxEVK6T_HDOP...
%         ,'.','color',PlotColorCode(7,:));
%     hold off; grid on; box on;
%     xlabel('time [sec]'); ylabel('HDOP []');
%     legend('Meas OEM6',...
%         'Meas Ublox');
%     %% Positioning Mode
%     Row = 1;
%     Column = 4;
%     figure('NumberTitle','off','Name','Positioning Mode','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     scrsz(4)/PlotArrSize(2)*(PlotArrSize(2)-Row) ...
%         scrsz(3)/PlotArrSize(1)                scrsz(4)/PlotArrSize(2) ]           );  % [left, bottom, width, height]
%     
%     subplot(211)
%     hold on;
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgOEM6_State_UpdateMode.OEM6_TimeUpdateMode...
%         ,'.','color',PlotColorCode(1,:));
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgUbloxEVK6T_State_UpdateMode.UbloxEVK6T_TimeUpdateMode...
%         ,'.','color',PlotColorCode(3,:));
%     hold off; grid on; box on;
%     xlabel('time [sec]'); ylabel('Time upd []');
%     legend('State OEM6',...
%         'State Ublox');
%     
%     subplot(212)
%     hold on;
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgOEM6_State_UpdateMode.OEM6_MeauUpdateMode...
%         ,'.','color',PlotColorCode(1,:));
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgUbloxEVK6T_State_UpdateMode.UbloxEVK6T_TimeUpdateMode...
%         ,'.','color',PlotColorCode(3,:));
%     hold off; grid on; box on;
%     xlabel('time [sec]'); ylabel('Meas upd []');
%     legend('State OEM6',...
%         'State Ublox');
% end
% %% 02.3 IVS Plot
% if Cfg_IVS_Plot_on == 1
%     %% Yawrate, lon acc
%     Row = 2;
%     Column = 1;
%     figure('NumberTitle','off','Name','Yawrate&LonAcc','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     scrsz(4)/PlotArrSize(2)*(PlotArrSize(2)-Row) ...
%         scrsz(3)/PlotArrSize(1)                scrsz(4)/PlotArrSize(2) ]           );  % [left, bottom, width, height]
%     
%     subplot(211)
%     hold on;
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgA1ESP2.YAW_RATE...
%         ,'.','color',PlotColorCode(12,:));
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgIMU_Rate.IMU_RateZ...
%         ,'.','color',PlotColorCode(11,:));
%     hold off; grid on; box on;
%     xlabel('time [sec]'); ylabel('Yawrate [deg]');
%     legend('OBS',...
%         'IMU');
%     
%     subplot(212)
%     hold on;
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgA1ESP2.LONG_ACCEL...
%         ,'.','color',PlotColorCode(12,:));
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgIMU_Acc.IMU_AccX...
%         ,'.','color',PlotColorCode(11,:));
%     hold off; grid on; box on;
%     xlabel('time [sec]'); ylabel('Lon acc [m/s^2]');
%     legend('OBS',...
%         'IMU');
%     %% Wheelspeed & pulse
%     Row = 2;
%     Column = 2;
%     figure('NumberTitle','off','Name','Wheel speed&pulse','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     scrsz(4)/PlotArrSize(2)*(PlotArrSize(2)-Row) ...
%         scrsz(3)/PlotArrSize(1)                scrsz(4)/PlotArrSize(2) ]           );  % [left, bottom, width, height]
%     
%     subplot(311)
%     hold on;
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgA1WHL_SPD.WHL_SPD_RL...
%         ,'.','color',PlotColorCode(2,:));
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgA1WHL_SPD.WHL_SPD_RR...
%         ,'.','color',PlotColorCode(3,:));
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgA1WHL_SPD.WHL_SPD_FL...
%         ,'.','color',PlotColorCode(4,:));
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgA1WHL_SPD.WHL_SPD_FR...
%         ,'.','color',PlotColorCode(5,:));
%     hold off; grid on; box on;
%     xlabel('time [sec]'); ylabel('wheel speed [m/s]');
%     legend('RL','RR','FL','FR');
%     
%     subplot(312)
%     hold on;
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgA1WHL_PUL.WHL_PUL_RL...
%         ,'.','color',PlotColorCode(2,:));
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgA1WHL_PUL.WHL_PUL_RR...
%         ,'.','color',PlotColorCode(3,:));
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgA1WHL_PUL.WHL_PUL_FL...
%         ,'.','color',PlotColorCode(4,:));
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgA1WHL_PUL.WHL_PUL_FR...
%         ,'.','color',PlotColorCode(5,:));
%     hold off; grid on; box on;
%     xlabel('time [sec]'); ylabel('pulse cnt []');
%     legend('RL','RR','FL','FR');
%     
%     subplot(313)
%     hold on;
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgA1WHL_PUL.WHL_DIR_RL...
%         ,'.','color',PlotColorCode(2,:));
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgA1WHL_PUL.WHL_DIR_RR...
%         ,'.','color',PlotColorCode(3,:));
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgA1WHL_PUL.WHL_DIR_FL...
%         ,'.','color',PlotColorCode(4,:));
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgA1WHL_PUL.WHL_DIR_FR...
%         ,'.','color',PlotColorCode(5,:));
%     hold off; grid on; box on;
%     xlabel('time [sec]'); ylabel('Direction []');
%     legend('RL','RR','FL','FR');
%     
%     %% Steering angle
%     Row = 2;
%     Column = 3;
%     figure('NumberTitle','off','Name','Steering angle','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     scrsz(4)/PlotArrSize(2)*(PlotArrSize(2)-Row) ...
%         scrsz(3)/PlotArrSize(1)                scrsz(4)/PlotArrSize(2) ]           );  % [left, bottom, width, height]
%     hold on;
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgA1MDPS2.CF_Mdps_StrAng...
%         ,'.-','color',PlotColorCode(10,:));
%     hold off; grid on; box on;
%     xlabel('time [sec]'); ylabel('Str angle [deg]');
%     
% end
% %% 02.4 Transmission Plot
% if Cfg_TRANS_Plot_on == 1
%     %% FrMsgTransmissionCtrl
%     Row = 2;
%     Column = 4;
%     figure('NumberTitle','off','Name','Transmission Ctrl','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     scrsz(4)/PlotArrSize(2)*(PlotArrSize(2)-Row) ...
%         scrsz(3)/PlotArrSize(1)                scrsz(4)/PlotArrSize(2) ]           );  % [left, bottom, width, height]
%     hold on;
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgTransmissionCtrl.sigGearClearErrorCmd...
%         ,'.-','color',PlotColorCode(10,:));
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgTransmissionCtrl.sigGearTargetPos...
%         ,'.-','color',PlotColorCode(11,:));
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgTransmissionCtrl.sigGearTorqueCtrlMode...
%         ,'.-','color',PlotColorCode(12,:));
%     hold off; grid on; box on;
%     xlabel('time [sec]'); ylabel('Str angle [deg]');
%     legend('sigGearClearErrorCmd','sigGearTargetPos','sigGearTorqueCtrlMode');
%     
%     %% FrMsgTransmissionStatus
%     Row = 3;
%     Column = 1;
%     figure('NumberTitle','off','Name','Transmission status','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     scrsz(4)/PlotArrSize(2)*(PlotArrSize(2)-Row) ...
%         scrsz(3)/PlotArrSize(1)                scrsz(4)/PlotArrSize(2) ]           );  % [left, bottom, width, height]
%     hold on;
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgTransmissionStatus.sigGearCurPos...
%         ,'.-','color',PlotColorCode(10,:));
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgTransmissionStatus.sigGearCurLockPos...
%         ,'.-','color',PlotColorCode(11,:));
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgTransmissionStatus.sigGearErrorState...
%         ,'.-','color',PlotColorCode(12,:));
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgTransmissionStatus.sigCompleteGear...
%         ,'.-','color',PlotColorCode(2,:));
%     hold off; grid on; box on;
%     xlabel('time [sec]'); ylabel(' []');
%     legend('sigGearCurPos','sigGearCurLockPos','sigGearErrorState','sigCompleteGear');
% end
% %% 02.5 Autonomous Plot
% if Cfg_Autonomous_Plot_on == 1
%     
%     %% Autonomous Modes
%     Row = 3;
%     Column = 2;
%     figure('NumberTitle','off','Name','Autonomous mode','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     scrsz(4)/PlotArrSize(2)*(PlotArrSize(2)-Row) ...
%         scrsz(3)/PlotArrSize(1)                scrsz(4)/PlotArrSize(2) ]           );  % [left, bottom, width, height]
%     hold on;
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgModeManagement.sigOperationMode...
%         ,'.-','color',PlotColorCode(10,:));
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgModeManagement.sigAutonomousMode...
%         ,'.-','color',PlotColorCode(11,:));
%     hold off; grid on; box on;
%     xlabel('time [sec]'); ylabel(' []');
%     legend('sigOperationMode','sigAutonomousMode');
%     
%     %% Control Modes
%     Row = 3;
%     Column = 3;
%     figure('NumberTitle','off','Name','Control mode','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     scrsz(4)/PlotArrSize(2)*(PlotArrSize(2)-Row) ...
%         scrsz(3)/PlotArrSize(1)                scrsz(4)/PlotArrSize(2) ]           );  % [left, bottom, width, height]
%     hold on;
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgA1VehicleControlCmd.sigParkingModeOnOff...
%         ,'.-','color',PlotColorCode(10,:));
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgA1VehicleControlCmd.sigStopFlag...
%         ,'.-','color',PlotColorCode(11,:));
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgA1VehicleControlCmd.sigControlMode...
%         ,'.-','color',PlotColorCode(12,:));
%     hold off; grid on; box on;
%     xlabel('time [sec]'); ylabel(' []');
%     legend('sigParkingModeOnOff','sigStopFlag','sigControlMode');
%     
%     %% Targets
%     Row = 3;
%     Column = 4;
%     figure('NumberTitle','off','Name','Targets','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     scrsz(4)/PlotArrSize(2)*(PlotArrSize(2)-Row) ...
%         scrsz(3)/PlotArrSize(1)                scrsz(4)/PlotArrSize(2) ]           );  % [left, bottom, width, height]
%     
%     
%     subplot(311)
%     hold on;
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgA1VehicleControlCmd.sigSetSpeed_kph...
%         ,'.-','color',PlotColorCode(10,:));
%     hold off; grid on; box on;
%     xlabel('time [sec]'); ylabel('set speed [kph]');
%     legend('sigSetSpeed_kph');
%     
%     subplot(312)
%     hold on;
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgA1VehicleControlCmd.sigTargetSteeringAngle...
%         ,'.-','color',PlotColorCode(10,:));
%     hold off; grid on; box on;
%     xlabel('time [sec]'); ylabel('target steering []');
%     legend('sigTargetSteeringAngle');
%     
%     subplot(313)
%     hold on;
%     plot(BrainFlexRayFrames.Time,BrainFlexRayFrames.FrMsgA1VehicleControlCmd.sigTargetAcceleration...
%         ,'.-','color',PlotColorCode(10,:));
%     hold off; grid on; box on;
%     xlabel('time [sec]'); ylabel('target acc []');
%     legend('sigTargetAcceleration');
% end