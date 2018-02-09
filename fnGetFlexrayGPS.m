function [FlexRay_GPS] = fnGetfnGetFlexrayGPS( FlexRay_raw )
%%
% 2. data refining
% 2.1 extract required signals
Hour = FlexRay_raw.OEM6_UTC_Hour;
Min = FlexRay_raw.OEM6_UTC_Minuite;
Sec = FlexRay_raw.OEM6_UTC_Second;
CSec = FlexRay_raw.OEM6_UTC_Centisecond;
UTCTime = (Hour.*3600 + Min.*60 + Sec) .* 10 + CSec/10;

% 2.2 remove repeated signals
[FlexRay_GPS.UTCTime, idxUnique] = unique(UTCTime);
FlexRay_GPS.OEM6_Latitude = FlexRay_raw.OEM6_Latitude(idxUnique);
FlexRay_GPS.OEM6_Longitude = FlexRay_raw.OEM6_Longitude(idxUnique);
FlexRay_GPS.OEM6_Heading = FlexRay_raw.OEM6_Heading(idxUnique);
FlexRay_GPS.OEM6_GPSQuality = FlexRay_raw.OEM6_GPSQuality(idxUnique);
FlexRay_GPS.OEM6_State_Vxy = FlexRay_raw.OEM6_State_Vxy(idxUnique);


% FlexRay_GPS.OEM6_Longitude = FlexRay_raw.OEM6_Longitude(idxUnique);
% FlexRay_GPS.OEM6_Latitude = FlexRay_raw.OEM6_Latitude(idxUnique);

% %%
% % 3. Save signals
% TargetFlexRayFrames.Lat = OEM6_Latitude;
% TargetFlexRayFrames.Lon = OEM6_Longitude;
% TargetFlexRayFrames.Head = OEM6_Heading;
% Filename = 'BrainFlexrayParsing.mat';
% destination = File_path;
% saveFile = fullfile(destination, Filename);
% save(saveFile, 'TargetFlexRayFrames');

end

