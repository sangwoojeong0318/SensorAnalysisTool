clear all; addpath('functions'); %close all;
CAN_sig_path = 'D:\User\Sangwoo\git\SensorAnalysisTool\Logging\180219\180219_Katri_M021.mat';
CAN_raw = load(CAN_sig_path);

Flexray_sig_path = 'D:\User\Sangwoo\git\SensorAnalysisTool\Logging\180219\KATRI_A1_01.mat';
FlexRay_raw = load(Flexray_sig_path);

object_list_radar = fnGetRadarObj(CAN_raw);
object_list_stereo = fnGetStereoObj(CAN_raw);
CAN_GPS = fnGetCANGPS(CAN_raw);
FlexRay_GPS = fnGetFlexrayGPS(FlexRay_raw);

% Coord cvt
[Synched_FR_Idx, Synched_CAN_Idx] = fnSynchronizer(FlexRay_GPS.UTCTime, CAN_GPS.UTCTime);
EgoVehicle.sig_State_Lat = CAN_GPS.sig_State_Lat(Synched_CAN_Idx);
EgoVehicle.sig_State_Lon = CAN_GPS.sig_State_Lon(Synched_CAN_Idx);
EgoVehicle.sig_State_Hdg = CAN_GPS.sig_State_Hdg(Synched_CAN_Idx);
TargetVehicle.OEM6_Latitude = FlexRay_GPS.OEM6_Latitude(Synched_FR_Idx);
TargetVehicle.OEM6_Longitude = FlexRay_GPS.OEM6_Longitude(Synched_FR_Idx);
TargetVehicle.OEM6_Heading = FlexRay_GPS.OEM6_Heading(Synched_FR_Idx);

figure();
mask = FlexRay_GPS.OEM6_Latitude ~= 0;
plot(FlexRay_GPS.OEM6_Latitude(mask), FlexRay_GPS.OEM6_Longitude(mask), '.-', 'Linewidth', 1);

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
HeadingCorrection = 180.-1.4321-3;
[TargetVehicle.X_local, TargetVehicle.Y_local] = fnCoordCvt_llh2local(EgoVehicle.enu, EgoVehicle.sig_State_Hdg - HeadingCorrection, ...
    TargetVehicle.enu - EgoVehicle.enu, TargetVehicle.OEM6_Heading);

%% Plot
% plot ref pos
figure(99);
plot(TargetVehicle.Y_local, TargetVehicle.X_local, '.-', 'Linewidth', 1);
title('Reference pos');
axis equal; xlim([-20, 20]); ylim([-5, 100]);

% Plot radar
nFig = 100;
figure(nFig); clf;
k = keys(object_list_radar);
leg_list = {};
for i=1:size(k,2)
    leg_list{i}=['ID = ', k{i}];
    obj = object_list_radar(k{i});
    figure(nFig); plot(obj.pos_y_m(:,2), obj.pos_x_m(:,2), '.'); 
    hold on; grid on; axis equal; xlim([-20, 20]); ylim([-5, 100]);
%     pause();
end
title('Radar objects');
legend(leg_list);
% 
% subplot(2,1,2);
% for t = 1:size(obj.pos_y_m,1)
% obj = object_list_radar('4');    
%     figure(1); plot(obj.pos_y_m(t,2), obj.pos_x_m(t,2), '.-b'); hold on;
%     grid on; axis equal; xlim([-10, 10]); ylim([-5, 100]);
%     %pause(0.001);
% end

% Plot stereo
nFig = nFig + 1;
figure(nFig); clf;
k = keys(object_list_stereo);
leg_list = {};
for i=1:size(k,2)
    leg_list{i}=['ID = ', k{i}];
    obj = object_list_stereo(k{i});
    figure(nFig); plot(obj.pos_y_m(:,2), obj.pos_x_m(:,2), '.'); 
    hold on; grid on; axis equal; xlim([-20, 20]); ylim([-5, 100]);
%     pause();
end
title('Stereo objects');
legend(leg_list);

%%
nFig = nFig + 1;
figure(nFig);
plot(TargetVehicle.Y_local, TargetVehicle.X_local, 'g.-', 'Linewidth', 1); hold on;
k = keys(object_list_radar);
for i=1:size(k,2)
    obj = object_list_radar(k{i});
    figure(nFig); plot(obj.pos_y_m(:,2), obj.pos_x_m(:,2), '.r'); 
    hold on; grid on; axis equal; xlim([-20, 20]); ylim([-5, 100]);
end
legend('RTK GPS', 'Radar');

nFig = nFig + 1;
figure(nFig);
plot(TargetVehicle.Y_local, TargetVehicle.X_local, 'g.-', 'Linewidth', 1); hold on;
k = keys(object_list_stereo);
for i=1:size(k,2)
    obj = object_list_stereo(k{i});
    figure(nFig); plot(obj.pos_y_m(:,2), obj.pos_x_m(:,2), '.b'); 
    hold on; grid on; axis equal; xlim([-20, 20]); ylim([-5, 100]);
end

legend('RTK GPS', 'Stereo');