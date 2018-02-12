clear all; addpath('functions');
CAN_sig_path = 'D:\10_DB\SensorAnalysis\[180208]_KATRI_Zoe1\KATRI_Zoe1_008.mat';
CAN_raw = load(CAN_sig_path);
object_list = fnGetRadarObj(CAN_raw);
%%
figure(1); clf;
k = keys(object_list);
leg_list = {};
for i=1:size(k,2)
    leg_list{i}=['ID = ', k{i}];
    obj = object_list(k{i});
    figure(1); plot(obj.pos_y_m(:,2), obj.pos_x_m(:,2), '.'); 
    hold on; grid on; axis equal; xlim([-20, 20]); ylim([-5, 100]);
    disp(k{i});
    pause();
end
legend(leg_list);

%%
figure(1); clf;
for t = 1:size(obj.pos_y_m,1)
obj = object_list('4');    
    figure(1); plot(obj.pos_y_m(t,2), obj.pos_x_m(t,2), '.-b'); hold on;
    grid on; axis equal; xlim([-10, 10]); ylim([-5, 100]);
    %pause(0.001);
end


