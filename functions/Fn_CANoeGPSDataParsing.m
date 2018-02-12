function CANoeGPS_DataFrames = Fn_CANoeGPSDataParsing( Logging_mat_path )
%%  File Name: Fn_CANoeGPSDataParsing.m
%  Description: CANoe GPS data parsing
%  Author: Wooyoung Lee
%  Copyright(C) 2017 ACE Lab, All Right Reserved.
% *************************************************************************

%% Parameters definition
CutIdx = 100;

% Data import
load(Logging_mat_path);

%%

% Ref_llh_Fr = [OEM6_State_Latitude(CutIdx), OEM6_State_Longitude(CutIdx)];
% enu = FnFast_llh2enu(Ref_llh(1), Ref_llh(2), PosLat(CutIdx:end), PosLon(CutIdx:end), PosAlt(CutIdx:end));


% ApproxEnu = FnFast_llh2enu(Ref_llh(1), Ref_llh(2), ApproxPosLat(100:end), ApproxPosLon(100:end), ApproxPosAlt(100:end));

tmp_UTC_time = OEM6_UTC_Hour(CutIdx:end)*3600 + OEM6_UTC_Minuite(CutIdx:end)*60 + OEM6_UTC_Second(CutIdx:end) + OEM6_UTC_Centisecond(CutIdx:end)/100;

tmp_Time = Time(CutIdx:end);
UTC_time = tmp_UTC_time;
for nIndex = 2:length(tmp_UTC_time)
    if (tmp_UTC_time(nIndex) == tmp_UTC_time(nIndex -1)) || (tmp_UTC_time(nIndex) < UTC_time(nIndex-1))
        UTC_time(nIndex) = UTC_time(nIndex-1) + (tmp_Time(nIndex) - tmp_Time(nIndex-1));
    end
end
% tmp_diffTime = diff(tmp_Time);
% tmp_diffDist = sqrt(diff(FrEnu(:,1)).^2 + diff(FrEnu(:,2)).^2);
% tmp_Heading = atand(diff(FrEnu(:,2))./diff(FrEnu(:,1)));
% tmp_Vel = tmp_diffDist ./ tmp_diffTime;
% tmp_Vx = tmp_Vel .* cosd(tmp_Heading);
% tmp_Vy = tmp_Vel .* sind(tmp_Heading);
% 
% 
% tmp_Acc = sqrt((diff(tmp_Vx).^2)+(diff(tmp_Vy).^2)) ./ tmp_diffTime(1:end-1);
% 
% tmp = sqrt(diff(FrEnu(:,1)).^2 + diff(FrEnu(:,2)).^2);
CANoeGPS_DataFrames.Time = tmp_Time;
CANoeGPS_DataFrames.UTCtime = UTC_time;
CANoeGPS_DataFrames.Lat =  OEM6_State_Latitude(CutIdx:end);
CANoeGPS_DataFrames.Lon =  OEM6_State_Longitude(CutIdx:end);
% CANoeGPS_DataFrames.Height =  ??;
CANoeGPS_DataFrames.Vel = OEM6_State_Vxy(CutIdx:end);
CANoeGPS_DataFrames.Acc = OEM6_State_a_xy(CutIdx:end);
CANoeGPS_DataFrames.Heading = OEM6_State_Heading(CutIdx:end);

Ref_llh = [CANoeGPS_DataFrames.Lat(1), CANoeGPS_DataFrames.Lon(1)];
FrEnu = FnFast_llh2enu(Ref_llh(1), Ref_llh(2), CANoeGPS_DataFrames.Lat, CANoeGPS_DataFrames.Lon);
CANoeGPS_DataFrames.ref = Ref_llh;
CANoeGPS_DataFrames.enu = FrEnu;
CANoeGPS_DataFrames.IsValid = OEM6_GPSQuality(CutIdx:end) == 4;
CANoeGPS_DataFrames.Hour = OEM6_UTC_Hour(CutIdx:end);
CANoeGPS_DataFrames.Minute = OEM6_UTC_Minuite(CutIdx:end);
CANoeGPS_DataFrames.Second = OEM6_UTC_Second(CutIdx:end);
% Data add
% velocity
% accel
% heading
end

