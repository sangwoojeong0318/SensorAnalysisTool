function CAN_GPS = fnGetCANGPS(CAN_raw)
% Get ego vehicle info
UTCTime = CAN_raw.GPS_Type(:,1) * 10;

[CAN_GPS.UTCTime, idxUnique] = unique(UTCTime);
CAN_GPS.sig_State_Lat = CAN_raw.sig_State_Lat(idxUnique);
CAN_GPS.sig_State_Lon = CAN_raw.sig_State_Lon(idxUnique);
CAN_GPS.sig_State_Hdg = CAN_raw.sig_State_Hdg(idxUnique);
CAN_GPS.VehicleSpeed = CAN_raw.VehicleSpeed(idxUnique);
end

