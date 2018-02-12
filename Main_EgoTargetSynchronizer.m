%%  File Name: Main_BrainFlexRayAnalysis.m
%  Description: Brain FlexRay data parsing
%  Copyright(C) 2014 ACE Lab, All Right Reserved.
% *************************************************************************
clc; clear all; close all;

%% 00. Configuration
db_mat_Path = 'DB\AutonomousFlexRay_DB.mat';
StereoAnalysis = true;
ViewStereoVideo = false;

RadarAnalysis = true;
ViewRadarVideo = false;

%% 01. Load the logging data
% 1.1 extract GPS from FlexRay
Flexray_sig_path = 'D:\10_DB\SensorAnalysis\[180208]_KATRI_Zoe1\KATRI_A1_22.mat';
FlexRay_raw = load(Flexray_sig_path);

FlexRay_GPS = fnGetFlexrayGPS(FlexRay_raw);

% 1.2 extract GPS from CAN
CAN_sig_path = 'D:\10_DB\SensorAnalysis\[180208]_KATRI_Zoe1\KATRI_Zoe1_008.mat';
CAN_raw = load(CAN_sig_path);
CAN_GPS = fnGetCANGPS(CAN_raw);

% 1.3 extract stereo object from CAN
if StereoAnalysis == true
    StereoObj = fnGetStereoObj(CAN_raw);
end

% 1.4 extract valeo radar object from CAN
if RadarAnalysis == true
    RadarObj = fnGetRadarObj(CAN_raw);
end

%% 02. Time synchronization
% SynchedInfo = fnSynchronizer(EgoInfo, TargetInfo);
[Synched_FR_Idx, Synched_CAN_Idx] = fnSynchronizer(FlexRay_GPS.UTCTime, CAN_GPS.UTCTime);

TargetVehicle.UTCTime = FlexRay_GPS.UTCTime(Synched_FR_Idx);
TargetVehicle.OEM6_Latitude = FlexRay_GPS.OEM6_Latitude(Synched_FR_Idx);
TargetVehicle.OEM6_Longitude = FlexRay_GPS.OEM6_Longitude(Synched_FR_Idx);
TargetVehicle.OEM6_Heading = FlexRay_GPS.OEM6_Heading(Synched_FR_Idx);
TargetVehicle.OEM6_GPSQuality = FlexRay_GPS.OEM6_GPSQuality(Synched_FR_Idx);
TargetVehicle.OEM6_State_Vxy = FlexRay_GPS.OEM6_State_Vxy(Synched_FR_Idx);

EgoVehicle.UTCTime = CAN_GPS.UTCTime(Synched_CAN_Idx);
EgoVehicle.sig_State_Lat = CAN_GPS.sig_State_Lat(Synched_CAN_Idx);
EgoVehicle.sig_State_Lon = CAN_GPS.sig_State_Lon(Synched_CAN_Idx);
EgoVehicle.sig_State_Hdg = CAN_GPS.sig_State_Hdg(Synched_CAN_Idx);
EgoVehicle.VehicleSpeed = CAN_GPS.VehicleSpeed(Synched_CAN_Idx);

if StereoAnalysis == true
    Object.Stereo.ID = StereoObj.ID(:, Synched_CAN_Idx);
    Object.Stereo.Valid = StereoObj.Valid(:, Synched_CAN_Idx);
    Object.Stereo.X_m = StereoObj.X(:, Synched_CAN_Idx);
    Object.Stereo.Y_m = StereoObj.Y(:, Synched_CAN_Idx);
end

if RadarAnalysis == true
    Object.Radar.ID = RadarObj.Object_ID(:, Synched_CAN_Idx);
    Object.Radar.Valid = RadarObj.Valid(:, Synched_CAN_Idx);
    Object.Radar.X_m = RadarObj.x_m(:, Synched_CAN_Idx);
    Object.Radar.Y_m = RadarObj.y_m(:, Synched_CAN_Idx);
end

%% 03. Coord cvt
% from llh to enu
for idx = 1:1:size(EgoVehicle.sig_State_Lat,1)
    if(abs(EgoVehicle.sig_State_Lat(idx)-37.) < 5.0 && abs(EgoVehicle.sig_State_Lon(idx)-126.0) < 5.0)
        RefPos.Lat = EgoVehicle.sig_State_Lat(idx);
        RefPos.Lon = EgoVehicle.sig_State_Lon(idx);
        break;
    end
end

EgoVehicle.enu = FnFast_llh2enu(RefPos.Lat, RefPos.Lon, EgoVehicle.sig_State_Lat, EgoVehicle.sig_State_Lon);
TargetVehicle.enu = FnFast_llh2enu(RefPos.Lat, RefPos.Lon, TargetVehicle.OEM6_Latitude, TargetVehicle.OEM6_Longitude);

% from enu to vehicle local coord
[TargetVehicle.X_local, TargetVehicle.Y_local] = fnCoordCvt_llh2local(EgoVehicle.enu, EgoVehicle.sig_State_Hdg, ...
    TargetVehicle.enu - EgoVehicle.enu, TargetVehicle.OEM6_Heading);

%% 04. Data association
% fnDataAssociation(Object.Stereo.X_m, Object.Stereo.Y_m, TargetVehicle.X_local, TargetVehicle.Y_local);

%% 05. Plot

% 5.1 Ego vehicle coordinate
% Draw stereo/radar
if StereoAnalysis == true || RadarAnalysis == true
    figure('Position',[1,1,400,1000]);
    subplot(5,2,1:10);

    plot(TargetVehicle.Y_local, TargetVehicle.X_local, '.-'); hold on;
    
    if StereoAnalysis == true
        fnPlotObject(Object.Stereo, 'go');
%         fnDrawBoundary(Object.Stereo);
    end
    if RadarAnalysis == true
        fnPlotObject(Object.Radar, 'r^');
%         fnDrawBoundary(Object.Radar);
    end
        
    legend('GPS', 'Stereo', 'Radar');
    xlabel('Y(m)'); ylabel('X(m)');
    axis equal; hold off; grid on;
    ylim([-10 100]); xlim([-20 20]);
end

% % Draw radar
% if RadarAnalysis == true
%     figure('Position',[401,1,400,1000]);
%     subplot(5,2,1:10);
% 
%     plot(TargetVehicle.Y_local, TargetVehicle.X_local, '.-'); hold on;
%     fnPlotObject(Object.Radar, 'g^');
%     fnDrawBoundary(Object.Radar);
% 
%     legend('GPS', 'Radar');
%     xlabel('Y(m)'); ylabel('X(m)');
%     axis equal; hold off; grid on;
% end

% 5.2 ENU coordinate
% Draw objects
if StereoAnalysis == true
    figure(3);
    plot(EgoVehicle.enu(1, 1), EgoVehicle.enu(1, 2), 'black.'); hold on;
    axis equal;
    grid on;
    xlabel('E(m)'); ylabel('N(m)');

    for idxFrame = 1:1:size(EgoVehicle.enu, 1)
        plot(EgoVehicle.enu(idxFrame,1), EgoVehicle.enu(idxFrame,2), 'r.-'); hold on;
        plot(TargetVehicle.enu(idxFrame,1), TargetVehicle.enu(idxFrame,2), 'b.-');
        
        if ViewStereoVideo == true && StereoAnalysis == true
            for idx = 1:1:size(Object.Stereo.X_m, 1)
                ObjectEnu = fnCoordCvt_local2enu(EgoVehicle.enu(idxFrame, :), EgoVehicle.sig_State_Hdg(idxFrame), Object.Stereo.X_m(idx,idxFrame), Object.Stereo.Y_m(idx,idxFrame), Object.Stereo.Valid(idx,idxFrame));
                plot(ObjectEnu(:,1), ObjectEnu(:,2), 'go');
            end
%             fnPlayVideo(EgoVehicle, TargetVehicle, Object.Stereo);
        end
        
        if ViewRadarVideo == true && RadarAnalysis == true
            for idx = 1:1:size(Object.Radar.X_m, 1)
                ObjectEnu = fnCoordCvt_local2enu(EgoVehicle.enu(idxFrame, :), EgoVehicle.sig_State_Hdg(idxFrame), Object.Radar.X_m(idx,idxFrame), Object.Radar.Y_m(idx,idxFrame), Object.Radar.Valid(idx,idxFrame));
                plot(ObjectEnu(:,1), ObjectEnu(:,2), 'r^');
            end
        end
        pause(0.01);
    end
    legend('Initial pos', 'Ego vehicle', 'Target vehicle', 'Stereo Obj', 'Radar Obj');
    hold off;
end

% % Draw radar
% if RadarAnalysis == true
%     figure(4);
%     plot(EgoVehicle.enu(1, 1), EgoVehicle.enu(1, 2), 'r.');hold on;
%     axis equal;
%     grid on;
%     xlabel('E(m)'); ylabel('N(m)');
% 
%     if ViewRadarVideo == true
%         fnPlayVideo(EgoVehicle, TargetVehicle, Object.Radar);
%     end
% 
%     cla;
%     plot(EgoVehicle.enu(:,1), EgoVehicle.enu(:,2), 'r.'); hold on;
%     plot(TargetVehicle.enu(:,1), TargetVehicle.enu(:,2), '.-');
%     for idx = 1:1:size(Object.Radar.X_m, 1)
%         figure(4);
%         ObjectEnu = fnCoordCvt_local2enu(EgoVehicle.enu, EgoVehicle.sig_State_Hdg, Object.Radar.X_m(idx,:), Object.Radar.Y_m(idx,:), Object.Radar.Valid(idx,:));
%         plot(ObjectEnu(:,1), ObjectEnu(:,2), 'g^');
%     end
%     legend('Ego vehicle', 'Target vehicle', 'Radar Obj');
% end

% 
% TargetVel = SynchedInfo.A1Vel_kph';
% % TargetAcc = CANoe_GPSDataFrames.Acc(Idx.TargetCANoe);
% TargetHeading = SynchedInfo.A1Pos.Head';
% TargetGPSValid = SynchedInfo.GPS.A1_GPSValid';
% 
% Idx.FlexRay = EgoPosLat';
% EastErr = nan(length(Idx.FlexRay),1);
% NorthErr = nan(length(Idx.FlexRay),1);
% Pos_Long = nan(length(Idx.FlexRay),1);
% Pos_Lat = nan(length(Idx.FlexRay),1);
% Vx_mps = nan(length(Idx.FlexRay),1);
% Vy_mps = nan(length(Idx.FlexRay),1);
% HeadingDiff = nan(length(Idx.FlexRay),1);
% TargetPosX = nan(length(Idx.FlexRay),1);
% TargetPosY = nan(length(Idx.FlexRay),1);
% TargetVelX = nan(length(Idx.FlexRay),1);
% TargetVelY = nan(length(Idx.FlexRay),1);
% TargetAccX = nan(length(Idx.FlexRay),1);
% TargetAccY = nan(length(Idx.FlexRay),1);
% 
% % Reference Time is FlexRay time
% for Erridx = 1 : 1: length(Idx.FlexRay)
%     if TargetGPSValid(Erridx) == 4
%         % Reference targe tvehicle position estimation
%         RotMat = [cosd(-EgoVehicle.sig_State_Hdg(Erridx)) -sind(-EgoVehicle.sig_State_Hdg(Erridx));
%             sind(-EgoVehicle.sig_State_Hdg(Erridx)) cosd(-EgoVehicle.sig_State_Hdg(Erridx))];
% 
%         tmp_CurrentPos = [TargetVehicle.enu(Erridx, 1) TargetVehicle.enu(Erridx, 2)]';
%         tmp_CurrentPos_VehCoord = RotMat*tmp_CurrentPos;
% 
%         % Distance difference between ego and target vehicle
%         EastErr(Erridx, 1) = (TargetVehicle.enu(Erridx, 1)) - EgoVehicle.enu(1);
%         NorthErr(Erridx, 1) = (TargetVehicle.enu(Erridx, 2)) - EgoVehicle.enu(2) ;
% 
%         % Heading difference between ego and target vehicle
%         HeadingDiff(Erridx, 1) = TargetHeading(Erridx, 1) - EgoVehicle.sig_State_Hdg(1); % [deg]
% 
%         % Target vehicle position respect to ego vehicle coordinate
%         TargetPosX(Erridx, 1) = tmp_CurrentPos_VehCoord(1);
%         TargetPosY(Erridx, 1) = tmp_CurrentPos_VehCoord(2);
% 
%         % Calculating the Vx and Vy
%         TargetVelX(Erridx, 1) = (TargetVel(Erridx, 1) - EgoVel(1)) * cosd(HeadingDiff(Erridx, 1));
%         TargetVelY(Erridx, 1) = (TargetVel(Erridx, 1) - EgoVel(1)) * sind(HeadingDiff(Erridx, 1));
% % 
% %         % Calculating the ax and ay
% %         TargetAccX(Erridx, 1) = (TargetAcc(Erridx, 1) - EgoAcc(1)) * cosd(HeadingDiff(Erridx, 1));
% %         TargetAccY(Erridx, 1) = (TargetAcc(Erridx, 1) - EgoAcc(1)) * sind(HeadingDiff(Erridx, 1));
%     end
% end
% 
% % Save reference data
% Target_RefData.Time = TargetTime;
% Target_RefData.EastErr = EastErr;
% Target_RefData.NorthErr = NorthErr;
% Target_RefData.PosX = TargetPosX;
% Target_RefData.PosY = TargetPosY;
% Target_RefData.Vel = TargetVel;
% Target_RefData.VelX = TargetVelX;
% Target_RefData.VelY = TargetVelY;
% Target_RefData.AccX = TargetAccX;
% Target_RefData.AccY = TargetAccY;
% Target_RefData.Heading = HeadingDiff;
% Target_RefData.ObjectFlag.Delphi = false(length(Target_RefData.PosX),1);
% Target_RefData.ObjectFlag.Stereo = SynchedInfo.Validity;
% Target_RefData.ObjectFlag.FusionBox = false(length(Target_RefData.PosX),1);
% 
% % Save stereo
% tmp_StereoErrList.bTrackValid = SynchedInfo.AssoObj.Valid';
% tmp_StereoErrList.Time = SynchedInfo.AssoObj.Time';
% tmp_StereoErrList.NumofObj = SynchedInfo.AssoObj.Valid';
% tmp_StereoErrList.nID = SynchedInfo.AssoObj.ID';
% tmp_StereoErrList.Valid = SynchedInfo.AssoObj.Valid';
% tmp_StereoErrList.PosX = SynchedInfo.AssoObj.X' - Target_RefData.PosX;
% tmp_StereoErrList.PosY = SynchedInfo.AssoObj.Y' - Target_RefData.PosY;
% tmp_StereoErrList.V = SynchedInfo.AssoObj.Vel_kph' - TargetVel;
% tmp_StereoErrList.Vx = SynchedInfo.AssoObj.VelX_kph' - Target_RefData.VelX;
% tmp_StereoErrList.Vy = SynchedInfo.AssoObj.VelY_kph' - Target_RefData.VelY;
% tmp_StereoErrList.Width = SynchedInfo.AssoObj.Valid';
% tmp_StereoErrList.Length = SynchedInfo.AssoObj.Valid';
% 
% for idx = 1:1:size(SynchedInfo.AssoObj.heading,2)
%     HeadingErr = SynchedInfo.AssoObj.heading(idx);
%     if HeadingErr >= 180
%        HeadingErr =  HeadingErr - 360;
%     end        
%     tmp_StereoErrList.Heading(idx, 1) = HeadingErr';
% end
% 
% tmp_StereoErrList.ref.Time = SynchedInfo.AssoObj.Time';
% tmp_StereoErrList.ref.nID = SynchedInfo.AssoObj.ID';
% tmp_StereoErrList.ref.Valid = SynchedInfo.AssoObj.Valid';
% tmp_StereoErrList.ref.PosX = SynchedInfo.AssoObj.X';
% tmp_StereoErrList.ref.PosY = SynchedInfo.AssoObj.Y';
% tmp_StereoErrList.ref.V = SynchedInfo.AssoObj.Vel_kph';
% tmp_StereoErrList.ref.Vx = SynchedInfo.AssoObj.VelX_kph';
% tmp_StereoErrList.ref.Vy = SynchedInfo.AssoObj.VelY_kph';
% tmp_StereoErrList.ref.Heading = SynchedInfo.AssoObj.heading';
% tmp_StereoErrList.ref.Width = SynchedInfo.AssoObj.Valid';
% tmp_StereoErrList.ref.Length = SynchedInfo.AssoObj.Valid';
% 
% 
% aSensorErrList.Stereo = tmp_StereoErrList;
% aSensorErrList.Reference = Target_RefData;
% 
% %% Save data
% % Synched signals
% tmp_Filename = strsplit(File_path,'\');
% Filename = 'SynchedSignals.mat';
% destination = File_path;
% saveFile = fullfile(destination, Filename);
% save(saveFile, 'aSensorErrList');