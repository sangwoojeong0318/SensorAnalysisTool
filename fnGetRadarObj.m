function StereoObj = fnGetRadarObj( CAN_raw )

% Get Radar info
rad2deg = 180.0 / 3.141592;
mps2kph = 3.6;

RadarMaxObj = 63;

Object_ID = 'CAN_raw.Object_ID_';
ReferencePoint = 'CAN_raw.ReferencePoint_';
Orientation_rad = 'CAN_raw.Orientation_rad_';
x_m = 'CAN_raw.x_m_';
y_m = 'CAN_raw.y_m_';
Length_m = 'CAN_raw.Length_m_';
Width_m = 'CAN_raw.Width_m_';

RadarObj.NumObject(1,:) = CAN_raw.NumObject;

RadarObj.Valid = zeros(RadarMaxObj, length(RadarObj.NumObject));
RadarObj.Object_ID = zeros(RadarMaxObj, length(RadarObj.NumObject));
RadarObj.ReferencePoint = zeros(RadarMaxObj, length(RadarObj.NumObject));
RadarObj.Orientation_rad = zeros(RadarMaxObj, length(RadarObj.NumObject));
RadarObj.x_m = zeros(RadarMaxObj, length(RadarObj.NumObject));
RadarObj.y_m = zeros(RadarMaxObj, length(RadarObj.NumObject));
RadarObj.Length_m = zeros(RadarMaxObj, length(RadarObj.NumObject));
RadarObj.Width_m = zeros(RadarMaxObj, length(RadarObj.NumObject));

for idx_data = 1 : 1 : length(RadarObj.NumObject)
    for idx_obj = 1 : 1 : RadarMaxObj
        if idx_obj <= RadarObj.NumObject(idx_data)
            SigObjectID = sprintf('%s%s(%s)', Object_ID, num2str(idx_obj), num2str(idx_data));
            SigReferencePoint = sprintf('%s%s(%s)', ReferencePoint, num2str(idx_obj), num2str(idx_data));
            SigOrientation_rad = sprintf('%s%s(%s)', Orientation_rad, num2str(idx_obj), num2str(idx_data));
            Sigx_m = sprintf('%s%s(%s)', x_m, num2str(idx_obj), num2str(idx_data));
            Sigy_m = sprintf('%s%s(%s)', y_m, num2str(idx_obj), num2str(idx_data));
            SigLength_m= sprintf('%s%s(%s)', Length_m, num2str(idx_obj), num2str(idx_data));
            SigWidth_m = sprintf('%s%s(%s)', Width_m, num2str(idx_obj), num2str(idx_data));
            
            RadarObj.Object_ID(idx_obj, idx_data) = eval(SigObjectID);
            RadarObj.ReferencePoint(idx_obj, idx_data) = eval(SigReferencePoint);
            RadarObj.Orientation_rad(idx_obj, idx_data) = eval(SigOrientation_rad);
            RadarObj.Length_m(idx_obj, idx_data) = eval(SigLength_m);
            RadarObj.Width_m(idx_obj, idx_data) = eval(SigWidth_m);
            
            tmp_x_m = eval(Sigx_m);
            tmp_y_m = eval(Sigy_m);
            tmp_ReferencePoint = RadarObj.ReferencePoint(idx_obj, idx_data);
            tmp_Orientation_rad = RadarObj.Orientation_rad(idx_obj, idx_data);
            tmp_Length_m = RadarObj.Length_m(idx_obj, idx_data);
            tmp_Width_m = RadarObj.Width_m(idx_obj, idx_data);
            tmp_Orientation_cos = cos(tmp_Orientation_rad);
            tmp_Orientation_sin = sin(tmp_Orientation_rad);
            
            if tmp_ReferencePoint == 0 %% Center of gravity
                RadarObj.Valid(idx_obj, idx_data) = 0;
            elseif tmp_ReferencePoint == 1 %% FL corner
                RadarObj.Valid(idx_obj, idx_data) = 1;
                RadarObj.x_m(idx_obj, idx_data) = tmp_x_m - tmp_Length_m / 2 * tmp_Orientation_cos + tmp_Width_m / 2 * tmp_Orientation_sin;
                RadarObj.y_m(idx_obj, idx_data) = tmp_y_m - tmp_Length_m / 2 * tmp_Orientation_sin - tmp_Width_m / 2 * tmp_Orientation_cos;
            elseif tmp_ReferencePoint == 2 %% FR corner
                RadarObj.Valid(idx_obj, idx_data) = 1;
                RadarObj.x_m(idx_obj, idx_data) = tmp_x_m - tmp_Length_m / 2 * tmp_Orientation_cos - tmp_Width_m / 2 * tmp_Orientation_sin;
                RadarObj.y_m(idx_obj, idx_data) = tmp_y_m - tmp_Length_m / 2 * tmp_Orientation_sin + tmp_Width_m / 2 * tmp_Orientation_cos;
            elseif tmp_ReferencePoint == 3 %% RR corner
                RadarObj.Valid(idx_obj, idx_data) = 1;
                RadarObj.x_m(idx_obj, idx_data) = tmp_x_m + tmp_Length_m / 2 * tmp_Orientation_cos - tmp_Width_m / 2 * tmp_Orientation_sin;
                RadarObj.y_m(idx_obj, idx_data) = tmp_y_m + tmp_Length_m / 2 * tmp_Orientation_sin + tmp_Width_m / 2 * tmp_Orientation_cos;
            elseif tmp_ReferencePoint == 4 %% RL corner
                RadarObj.Valid(idx_obj, idx_data) = 1;
                RadarObj.x_m(idx_obj, idx_data) = tmp_x_m + tmp_Length_m / 2 * tmp_Orientation_cos + tmp_Width_m / 2 * tmp_Orientation_sin;
                RadarObj.y_m(idx_obj, idx_data) = tmp_y_m + tmp_Length_m / 2 * tmp_Orientation_sin - tmp_Width_m / 2 * tmp_Orientation_cos;
            elseif tmp_ReferencePoint == 5 %% Center of Front
                RadarObj.Valid(idx_obj, idx_data) = 1;
                RadarObj.x_m(idx_obj, idx_data) = tmp_x_m - tmp_Length_m / 2 * tmp_Orientation_cos;
                RadarObj.y_m(idx_obj, idx_data) = tmp_y_m - tmp_Length_m / 2 * tmp_Orientation_sin;
            elseif tmp_ReferencePoint == 6 %% Center of right
                RadarObj.Valid(idx_obj, idx_data) = 1;
                RadarObj.x_m(idx_obj, idx_data) = tmp_x_m - tmp_Width_m / 2 * tmp_Orientation_sin;
                RadarObj.y_m(idx_obj, idx_data) = tmp_y_m + tmp_Width_m / 2 * tmp_Orientation_cos;
            elseif tmp_ReferencePoint == 7 %% Center of rear
                RadarObj.Valid(idx_obj, idx_data) = 1;
                RadarObj.x_m(idx_obj, idx_data) = tmp_x_m + tmp_Length_m / 2 * tmp_Orientation_cos;
                RadarObj.y_m(idx_obj, idx_data) = tmp_y_m + tmp_Length_m / 2 * tmp_Orientation_sin;
            elseif tmp_ReferencePoint == 8 %% Center of left
                RadarObj.Valid(idx_obj, idx_data) = 1;
                RadarObj.x_m(idx_obj, idx_data) = tmp_x_m + tmp_Width_m / 2 * tmp_Orientation_sin;
                RadarObj.y_m(idx_obj, idx_data) = tmp_y_m - tmp_Width_m / 2 * tmp_Orientation_cos;
            elseif tmp_ReferencePoint == 9 %% Center of box
                RadarObj.Valid(idx_obj, idx_data) = 1;
                RadarObj.x_m(idx_obj, idx_data) = tmp_x_m;
                RadarObj.y_m(idx_obj, idx_data) = tmp_y_m;
            elseif tmp_ReferencePoint == 15 %% Invalid
                RadarObj.Valid(idx_obj, idx_data) = 0;
            end
        end
    end
end
end