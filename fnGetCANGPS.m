function CAN_GPS = fnGetCANGPS(CAN_raw)
% Get ego vehicle info
UTCTime = CAN_raw.GPS_Type(:,1) * 10;

[tmp_UTCTime, idxUnique] = unique(UTCTime);
tmp_sig_State_Lat = CAN_raw.sig_State_Lat(idxUnique);
tmp_sig_State_Lon = CAN_raw.sig_State_Lon(idxUnique);
tmp_sig_State_Hdg = CAN_raw.sig_State_Hdg(idxUnique);
tmp_VehicleSpeed = CAN_raw.VehicleSpeed(idxUnique);

idxValid = tmp_sig_State_Lat ~= 0;
CAN_GPS.UTCTime = tmp_UTCTime(idxValid);
CAN_GPS.sig_State_Lat = tmp_sig_State_Lat(idxValid);
CAN_GPS.sig_State_Lon = tmp_sig_State_Lon(idxValid);
CAN_GPS.sig_State_Hdg = tmp_sig_State_Hdg(idxValid);
CAN_GPS.VehicleSpeed = tmp_VehicleSpeed(idxValid);
end

