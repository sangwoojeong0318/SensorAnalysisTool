clear all; close all;
% load data (A1)
[filename, filepath] = uigetfile();
load([filepath, filename]);

%%
% data parsing
% lat = TargetFlexRayFrames.Lat;
% lon = TargetFlexRayFrames.Lon;
lat = sig_State_Lat(:,1); lat = lat(lat~=0);
lon = sig_State_Lon(:,1); lon = lon(lon~=0);

% enu convesion
idxfilter = 0;
for idx = 1:1:size(lat,1)
    if isnan(lat(idx)) || lat(idx) == 0
        continue;
    elseif isnan(lon(idx)) || lon(idx) == 0
        continue;
    else
        if idxfilter == 1
            Ref_Lat = lat(idx);
            Ref_Lon = lon(idx);
        end
        
        idxfilter = idxfilter + 1;
        filtered_lat(idxfilter) = lat(idx);
        filtered_lon(idxfilter) = lon(idx);
    end
end
enu = FnFast_llh2enu(Ref_Lat, Ref_Lon, filtered_lat', filtered_lon');

% llh plot
figure();
plot(filtered_lat, filtered_lon,'or');
title('llh'); axis equal;

% enu plot
figure();
plot(enu(:,1), enu(:,2),'or');
title('enu'); axis equal;