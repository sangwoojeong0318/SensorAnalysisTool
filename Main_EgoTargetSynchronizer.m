%%  File Name: Main_BrainFlexRayAnalysis.m
%  Description: Brain FlexRay data parsing
%  Copyright(C) 2014 ACE Lab, All Right Reserved.
% *************************************************************************
clc; clear all; close all;

%% 00. Configuration
db_mat_Path = 'DB\AutonomousFlexRay_DB.mat';
StereoAnalysis = true;
ViewStereoVideo = true;

RadarAnalysis = false;
ViewRadarVideo = false;

if StereoAnalysis == false
    ViewStereoVideo = false;
end

if RadarAnalysis == false
    ViewRadarVideo = false;
end

%% 01. Load the logging data
% 1.1 extract GPS from FlexRay
Flexray_sig_path = 'F:\00_DB\DANGUN\SensorEvaluation\[180208]_[KATRI]\KATRI_A1_11.mat';
FlexRay_raw = load(Flexray_sig_path);

FlexRay_GPS = fnGetFlexrayGPS(FlexRay_raw);

% 1.2 extract GPS from CAN
CAN_sig_path = 'F:\00_DB\DANGUN\SensorEvaluation\[180208]_[KATRI]\KATRI_Zoe2_M011.mat';
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
Object.Stereo.Associated = fnDataAssociation(Object.Stereo, TargetVehicle);

%% 05. Plot

% 5.1 Ego vehicle coordinate
% Draw stereo/radar
if StereoAnalysis == true || RadarAnalysis == true
    figure('Position',[1,1,400,1000]);
    subplot(5,2,1:10);

    plot(TargetVehicle.Y_local, TargetVehicle.X_local, '.-'); hold on;
    
    if StereoAnalysis == true
        fnPlotObject(Object.Stereo.Associated, 'go');
        fnDrawBoundary(Object.Stereo);
    end
    if RadarAnalysis == true
        fnPlotObject(Object.Radar, 'r^');
        fnDrawBoundary(Object.Radar);
    end
        
    if StereoAnalysis == true && RadarAnalysis == true
        legend('GPS', 'Stereo', 'Radar');
    elseif StereoAnalysis == true && RadarAnalysis == false
        legend('GPS', 'Stereo');
    elseif StereoAnalysis == false && RadarAnalysis == true
        legend('GPS', 'Radar');
    else
        legend('GPS');
    end
    
    xlabel('Y(m)'); ylabel('X(m)');
    axis equal; hold off; grid on;
    ylim([-10 100]); xlim([-20 20]);
end

% % Draw radar
% 5.2 ENU coordinate
% Draw objects
if StereoAnalysis == true || RadarAnalysis == true
    figure(3);
    plot(EgoVehicle.enu(1, 1), EgoVehicle.enu(1, 2), 'black.'); hold on;
    axis equal;
    grid on;
    xlabel('E(m)'); ylabel('N(m)');

    for idxFrame = 1:1:size(EgoVehicle.enu, 1)
        plot(EgoVehicle.enu(idxFrame,1), EgoVehicle.enu(idxFrame,2), 'r.-'); hold on;
        plot(TargetVehicle.enu(idxFrame,1), TargetVehicle.enu(idxFrame,2), 'b.-');
        
        if ViewStereoVideo == true
            for idx = 1:1:size(Object.Stereo.X_m, 1)
                ObjectEnu = fnCoordCvt_local2enu(EgoVehicle.enu(idxFrame, :), EgoVehicle.sig_State_Hdg(idxFrame), Object.Stereo.X_m(idx,idxFrame), Object.Stereo.Y_m(idx,idxFrame), Object.Stereo.Valid(idx,idxFrame));
%                 plot(ObjectEnu(:,1), ObjectEnu(:,2), 'go');
            end
            ObjectEnu = fnCoordCvt_local2enu(EgoVehicle.enu(idxFrame, :), EgoVehicle.sig_State_Hdg(idxFrame), Object.Stereo.Associated.X_m(idxFrame), Object.Stereo.Associated.Y_m(idxFrame), Object.Stereo.Associated.Valid(idxFrame));
            plot(ObjectEnu(:,1), ObjectEnu(:,2), 'go');
%             fnPlotObject(Object.Stereo, 'go');
%             fnPlayVideo(EgoVehicle, TargetVehicle, Object.Stereo);
        end
        
        if ViewRadarVideo == true
            for idx = 1:1:size(Object.Radar.X_m, 1)
                ObjectEnu = fnCoordCvt_local2enu(EgoVehicle.enu(idxFrame, :), EgoVehicle.sig_State_Hdg(idxFrame), Object.Radar.X_m(idx,idxFrame), Object.Radar.Y_m(idx,idxFrame), Object.Radar.Valid(idx,idxFrame));
                plot(ObjectEnu(:,1), ObjectEnu(:,2), 'r^');
            end
        end
        pause(0.01);
    end
    
    if StereoAnalysis == true && RadarAnalysis == true
        legend('Initial pos', 'Ego GPS', 'Target GPS', 'Stereo Obj', 'Radar Obj');
    elseif StereoAnalysis == true && RadarAnalysis == false
        legend('Initial pos', 'Ego GPS', 'Target GPS', 'Stereo Obj');
    elseif StereoAnalysis == false && RadarAnalysis == true
        legend('Initial pos', 'Ego GPS', 'Target GPS', 'Radar Obj');
    else
        legend('Initial pos', 'Ego GPS', 'Target GPS');
    end
    hold off;
end