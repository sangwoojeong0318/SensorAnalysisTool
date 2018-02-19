clear all; addpath('functions');
CAN_sig_path = 'D:\User\Sangwoo\git\SensorAnalysisTool\DB\180219\test\KATRI_Zoe1_008.mat';
CAN_raw = load(CAN_sig_path);
object_list_radar = fnGetRadarObj(CAN_raw);
object_list_stereo = fnGetStereoObj(CAN_raw);

%% Plot
% Plot radar
figure(1); clf;
k = keys(object_list_radar);
leg_list = {};
for i=1:size(k,2)
    leg_list{i}=['ID = ', k{i}];
    obj = object_list_radar(k{i});
    figure(1); plot(obj.pos_y_m(:,2), obj.pos_x_m(:,2), '.'); 
    hold on; grid on; axis equal; xlim([-20, 20]); ylim([-5, 100]);
    pause();
end
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
figure(2); clf;
k = keys(object_list_stereo);
leg_list = {};
for i=1:size(k,2)
    leg_list{i}=['ID = ', k{i}];
    obj = object_list_stereo(k{i});
    figure(2); plot(obj.pos_y_m(:,2), obj.pos_x_m(:,2), '.'); 
    hold on; grid on; axis equal; xlim([-20, 20]); ylim([-5, 100]);
    pause();
end
legend(leg_list);
