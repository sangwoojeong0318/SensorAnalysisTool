%%  File Name: Main_BrainFlexRayAnalysis.m
%  Description: Brain FlexRay data parsing
%  Copyright(C) 2014 ACE Lab, All Right Reserved.
% *************************************************************************
clc; clear all; close all;
addpath('functions');
addpath('class');
addpath('plot');

%% 00. Configuration
% db_mat_Path = 'DB\AutonomousFlexRay_DB.mat';
StereoAnalysis = true;
ViewStereoVideo = false;

RadarAnalysis = true;
ViewRadarVideo = false;

if StereoAnalysis == false
    ViewStereoVideo = false;
end

if RadarAnalysis == false
    ViewRadarVideo = false;
end

%% 01. Load the logging data
% 1.1 extract GPS from FlexRay

Flexray_sig_path = 'D:\User\Sangwoo\git\SensorAnalysisTool\Logging\180219\KATRI_A1_271.mat';

FlexRay_raw = load(Flexray_sig_path);

FlexRay_GPS = fnGetFlexrayGPS(FlexRay_raw);

% 1.2 extract GPS from CAN
CAN_sig_path = 'D:\User\Sangwoo\git\SensorAnalysisTool\Logging\180219\180219_Katri_M018.mat';

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
% Erase repeted sensor data
% StereoObj = fnEraseRepeatedData(StereoObj);
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

% if RadarAnalysis == true
%     Object.Radar.ID = RadarObj.Object_ID(:, Synched_CAN_Idx);
%     Object.Radar.Valid = RadarObj.Valid(:, Synched_CAN_Idx);
%     Object.Radar.X_m = RadarObj.x_m(:, Synched_CAN_Idx);
%     Object.Radar.Y_m = RadarObj.y_m(:, Synched_CAN_Idx);
% end

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

%% 04. Objecgt association
if StereoAnalysis == true
    Object.Stereo = fnGetSynchedObj(TargetVehicle.UTCTime, TargetVehicle.X_local,  TargetVehicle.Y_local, StereoObj);
    object_containers_map = containers.Map;
%     for t = 1:size(Object.Stereo.ID,2)
%         time = Object.Stereo.ID(:,t);
%         id = Object.Stereo.ID(:,t);
%         [unique_id, ia, ic] = unique(id);
%         for i = 1:length(unique_id)
%             if unique_id(i) ~= 0                 
%                 pos_x = Object.Stereo.X_m(ia(i),t);
%                 pos_y = Object.Stereo.Y_m(ia(i),t);
%                 len = Object.Stereo.X_m(ia(i),t);
%                 width = Object.Stereo.X_m(ia(i),t);
%                 heading_angle_rad = Object.Stereo.X_m(ia(i),t);
% 
%                 if isKey(object_containers_map,num2str(unique_id(i))) == 1
%                     % existing id
%                     obj = object_containers_map(num2str(unique_id(i)));
% 
%                     % add data
%                     object_containers_map(num2str(unique_id(i))) = obj.add_data(time, pos_x, pos_y, heading_angle_rad, width, len);
%                 else
%                     % new id
%                     obj = object_class(unique_id(i));
%                     obj = obj.add_data(time, pos_x, pos_y, heading_angle_rad, width, len);
% 
%                     % register new key
%                     object_containers_map(num2str(unique_id(i))) = obj;
%                 end            
%             end
%         end
%     end
%     
%     figure(99); clf;
%     plot(TargetVehicle.X_local, TargetVehicle.Y_local, '.-', 'Linewidth', 1); hold on;
%     k = keys(object_containers_map);
%     leg_list = {};
%     for i=1:size(k,2)
%         leg_list{i}=['ID = ', k{i}];
%         obj = object_containers_map(k{i});
%         figure(99); plot(obj.pos_y_m(:,2), obj.pos_x_m(:,2), '.'); 
%         grid on; axis equal; xlim([-20, 20]); ylim([-5, 100]);
%         pause();
%     end
%     legend(leg_list);

end
if RadarAnalysis == true
    Object.Radar = fnGetSynchedObj(TargetVehicle.UTCTime, TargetVehicle.X_local,  TargetVehicle.Y_local, RadarObj);
end

%% 05. Calculate error
if StereoAnalysis == true
    MaskIdx = Object.Stereo.Valid == 1;
    [DistErr_X, DistErr_Y] = fnGetError(TargetVehicle.X_local(MaskIdx), TargetVehicle.Y_local(MaskIdx), Object.Stereo.X_m(MaskIdx), Object.Stereo.Y_m(MaskIdx));
    fnDisplayError(TargetVehicle.X_local(MaskIdx), DistErr_X, DistErr_Y);
end

if RadarAnalysis == true
    MaskIdx = Object.Radar.Valid == 1;
    [DistErr_X, DistErr_Y] = fnGetError(TargetVehicle.X_local(MaskIdx), TargetVehicle.Y_local(MaskIdx), Object.Radar.X_m(MaskIdx), Object.Radar.Y_m(MaskIdx));
    DistErr = sqrt(DistErr_X.*DistErr_X + DistErr_Y.*DistErr_Y);
    fnDisplayError(TargetVehicle.X_local(MaskIdx), DistErr_X, DistErr_Y);
end

%% 05. Plot
% figure();
% % Draw stereo shape
% if StereoAnalysis == true
%     for idxFrame = 1:1:length(Object.Stereo.X_mid_m)
%         for idxObj = 1:1:size(Object.Stereo.ID, 1)
%             if Object.Stereo.Valid(idxObj, idxFrame) == 1
%                 plot([Object.Stereo.X_right_m(idxObj, idxFrame), Object.Stereo.X_mid_m(idxObj, idxFrame), Object.Stereo.X_left_m(idxObj, idxFrame)], ...
%                     [Object.Stereo.Y_right_m(idxObj, idxFrame), Object.Stereo.Y_mid_m(idxObj, idxFrame), Object.Stereo.Y_left_m(idxObj, idxFrame)], 'ro-');
% %                 hold on;
%                 xlim([-5, 100]); ylim([-20, 20]);    
%                 xlabel('X(m)'); ylabel('Y(m)');
%                 axis equal; grid on;
%                 pause();
%             end
%         end
%     end
% end
% 5.1 Ego vehicle coordinate
% Draw stereo/radar
if StereoAnalysis == true || RadarAnalysis == true
    figure('Position',[1,1,1000,400]);
    subplot(5,2,1:10);

    plot(TargetVehicle.X_local, TargetVehicle.Y_local, '.-', 'Linewidth', 1); hold on;
    
    if StereoAnalysis == true
        fnPlotObject(Object.Stereo, 'go');
%         [FOV_L, FOV_R] = fnDrawBoundary(Object.Stereo);
%         fprintf(['Stereo FoV: ', num2str(FOV_R), ' ~ ', num2str(FOV_L), ' (deg)\n']);
    end
    if RadarAnalysis == true
        fnPlotObject(Object.Radar, 'r^');
%         [FOV_L, FOV_R] = fnDrawBoundary(Object.Radar);
%         fprintf(['Radar FoV: ', num2str(FOV_R), ' ~ ', num2str(FOV_L), ' (deg)\n']);
%         fnDrawBoundary(Object.Radar);
    end
        
    if StereoAnalysis == true && RadarAnalysis == true
        legend('RTK GPS', 'Stereo obj', 'Radar obj');
    elseif StereoAnalysis == true && RadarAnalysis == false
        legend('RTK GPS', 'Stereo obj');
    elseif StereoAnalysis == false && RadarAnalysis == true
        legend('RTK GPS', 'Radar obj');
    else
        legend('GPS');
    end
    
    xlabel('X(m)'); ylabel('Y(m)');
    axis equal; hold off; grid on;
%     title('Position
%     title(['FoV: ', num2str(abs(FOV_R-FOV_L)), ' deg (', num2str(FOV_R), ' deg ~ ', num2str(FOV_L), ' deg)']);
    xlim([-10 140]); ylim([-20 20]);
end

% % Draw radar
% 5.2 ENU coordinate
% Draw objects
if ViewStereoVideo == true || ViewRadarVideo == true
    figure(3);
    plot(EgoVehicle.enu(1, 1), EgoVehicle.enu(1, 2), 'black^'); hold on;
    axis equal;
    grid on;
    xlabel('E(m)'); ylabel('N(m)');

    for idxFrame = 1:1:size(EgoVehicle.enu, 1)
        plot(EgoVehicle.enu(idxFrame,1), EgoVehicle.enu(idxFrame,2), 'black.-'); hold on;
        plot(TargetVehicle.enu(idxFrame,1), TargetVehicle.enu(idxFrame,2), 'b.-');
        
        if ViewStereoVideo == true
            for idx = 1:1:size(Object.Stereo.X_m, 1)
                ObjectEnu = fnCoordCvt_local2enu(EgoVehicle.enu(idxFrame, :), EgoVehicle.sig_State_Hdg(idxFrame), Object.Stereo.X_m(idx,idxFrame), Object.Stereo.Y_m(idx,idxFrame), Object.Stereo.Valid(idx,idxFrame));
%                 plot(ObjectEnu(:,1), ObjectEnu(:,2), 'go');
            end
            ObjectEnu = fnCoordCvt_local2enu(EgoVehicle.enu(idxFrame, :), EgoVehicle.sig_State_Hdg(idxFrame), Object.Stereo.X_m(idxFrame), Object.Stereo.Y_m(idxFrame), Object.Stereo.Valid(idxFrame));
            plot(ObjectEnu(:,1), ObjectEnu(:,2), 'go');
%             fnPlotObject(Object.Stereo, 'go');
%             fnPlayVideo(EgoVehicle, TargetVehicle, Object.Stereo);
        end
        
        if ViewRadarVideo == true
            for idx = 1:1:size(Object.Radar.X_m, 1)
                ObjectEnu = fnCoordCvt_local2enu(EgoVehicle.enu(idxFrame, :), EgoVehicle.sig_State_Hdg(idxFrame), Object.Radar.X_m(idx,idxFrame), Object.Radar.Y_m(idx,idxFrame), Object.Radar.Valid(idx,idxFrame));
%                 plot(ObjectEnu(:,1), ObjectEnu(:,2), 'r^');
            end
            ObjectEnu = fnCoordCvt_local2enu(EgoVehicle.enu(idxFrame, :), EgoVehicle.sig_State_Hdg(idxFrame), Object.Radar.X_m(idxFrame), Object.Radar.Y_m(idxFrame), Object.Radar.Valid(idxFrame));
            plot(ObjectEnu(:,1), ObjectEnu(:,2), 'r^');
        end
        pause(0.01);
    end
    
    if ViewStereoVideo == true && ViewRadarVideo == true
        legend('Initial pos', 'Ego GPS', 'Target GPS', 'Stereo Obj', 'Radar Obj');
    elseif ViewStereoVideo == true && ViewRadarVideo == false
        legend('Initial pos', 'Ego GPS', 'Target GPS', 'Stereo Obj');
    elseif ViewStereoVideo == false && ViewRadarVideo == true
        legend('Initial pos', 'Ego GPS', 'Target GPS', 'Radar Obj');
    else
        legend('Initial pos', 'Ego GPS', 'Target GPS');
    end
    hold off;
end