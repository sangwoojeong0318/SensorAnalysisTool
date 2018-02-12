function object_containers_map = fnGetRadarObj( CAN_raw )
    if max(CAN_raw.Valid) == 0
        error('No radar data');
    end

    UTCTime = CAN_raw.GPS_Type(:,1) * 10;
    [tmpSpace, idxUnique] = unique(UTCTime);
    idxUnique = idxUnique(tmpSpace ~= 0);
    UTCTime = tmpSpace(tmpSpace ~= 0);

    % Get Radar info
    rad2deg = 180.0 / 3.141592;
    mps2kph = 3.6;

    RadarMaxObj = max(CAN_raw.NumObject);

    Object_ID = 'CAN_raw.Object_ID_';
    ReferencePoint = 'CAN_raw.ReferencePoint_';
    Orientation_rad = 'CAN_raw.Orientation_rad_';
    x_m = 'CAN_raw.x_m_';
    y_m = 'CAN_raw.y_m_';
    Length_m = 'CAN_raw.Length_m_';
    Width_m = 'CAN_raw.Width_m_';

    tmpRadarObj.NumObject(1,:) = CAN_raw.NumObject;

    for idx_obj = 1:1:RadarMaxObj
        SigObjectID = sprintf('%s%s', Object_ID, num2str(idx_obj));
        SigReferencePoint = sprintf('%s%s', ReferencePoint, num2str(idx_obj));
        SigOrientation_rad = sprintf('%s%s', Orientation_rad, num2str(idx_obj));
        Sigx_m = sprintf('%s%s', x_m, num2str(idx_obj));
        Sigy_m = sprintf('%s%s', y_m, num2str(idx_obj));
        SigLength_m= sprintf('%s%s', Length_m, num2str(idx_obj));
        SigWidth_m = sprintf('%s%s', Width_m, num2str(idx_obj));

        tmp_Object_ID(idx_obj, :) = eval(SigObjectID);
        tmpRadarObj.ReferencePoint(idx_obj, :) = eval(SigReferencePoint);
        tmpRadarObj.Orientation_rad(idx_obj, :) = eval(SigOrientation_rad);
        tmpRadarObj.Length_m(idx_obj, :) = eval(SigLength_m);
        tmpRadarObj.Width_m(idx_obj, :) = eval(SigWidth_m);
        tmp_x_m(idx_obj, :) = eval(Sigx_m);
        tmp_y_m(idx_obj, :) = eval(Sigy_m);

    end

    for idx_data = 1 : 1 : length(tmpRadarObj.NumObject)
        for idx_obj = 1 : 1 : RadarMaxObj
            if idx_obj <= tmpRadarObj.NumObject(idx_data)
                x_m = tmp_x_m(idx_obj, idx_data);
                y_m = tmp_y_m(idx_obj, idx_data);
                tmp_ReferencePoint = tmpRadarObj.ReferencePoint(idx_obj, idx_data);
                tmp_Orientation_rad = tmpRadarObj.Orientation_rad(idx_obj, idx_data);
                tmp_Length_m = tmpRadarObj.Length_m(idx_obj, idx_data);
                tmp_Width_m = tmpRadarObj.Width_m(idx_obj, idx_data);
                tmp_Orientation_cos = cos(tmp_Orientation_rad);
                tmp_Orientation_sin = sin(tmp_Orientation_rad);

                if tmp_ReferencePoint == 0 %% Center of gravity
                    tmpRadarObj.Valid(idx_obj, idx_data) = 0;
                elseif tmp_ReferencePoint == 1 %% FL corner
                    tmpRadarObj.Valid(idx_obj, idx_data) = 1;
                    tmpRadarObj.x_m(idx_obj, idx_data) = x_m - tmp_Length_m / 2 * tmp_Orientation_cos + tmp_Width_m / 2 * tmp_Orientation_sin;
                    tmpRadarObj.y_m(idx_obj, idx_data) = y_m - tmp_Length_m / 2 * tmp_Orientation_sin - tmp_Width_m / 2 * tmp_Orientation_cos;
                elseif tmp_ReferencePoint == 2 %% FR corner
                    tmpRadarObj.Valid(idx_obj, idx_data) = 1;
                    tmpRadarObj.x_m(idx_obj, idx_data) = x_m - tmp_Length_m / 2 * tmp_Orientation_cos - tmp_Width_m / 2 * tmp_Orientation_sin;
                    tmpRadarObj.y_m(idx_obj, idx_data) = y_m - tmp_Length_m / 2 * tmp_Orientation_sin + tmp_Width_m / 2 * tmp_Orientation_cos;
                elseif tmp_ReferencePoint == 3 %% RR corner
                    tmpRadarObj.Valid(idx_obj, idx_data) = 1;
                    tmpRadarObj.x_m(idx_obj, idx_data) = x_m + tmp_Length_m / 2 * tmp_Orientation_cos - tmp_Width_m / 2 * tmp_Orientation_sin;
                    tmpRadarObj.y_m(idx_obj, idx_data) = y_m + tmp_Length_m / 2 * tmp_Orientation_sin + tmp_Width_m / 2 * tmp_Orientation_cos;
                elseif tmp_ReferencePoint == 4 %% RL corner
                    tmpRadarObj.Valid(idx_obj, idx_data) = 1;
                    tmpRadarObj.x_m(idx_obj, idx_data) = x_m + tmp_Length_m / 2 * tmp_Orientation_cos + tmp_Width_m / 2 * tmp_Orientation_sin;
                    tmpRadarObj.y_m(idx_obj, idx_data) = y_m + tmp_Length_m / 2 * tmp_Orientation_sin - tmp_Width_m / 2 * tmp_Orientation_cos;
                elseif tmp_ReferencePoint == 5 %% Center of Front
                    tmpRadarObj.Valid(idx_obj, idx_data) = 1;
                    tmpRadarObj.x_m(idx_obj, idx_data) = x_m - tmp_Length_m / 2 * tmp_Orientation_cos;
                    tmpRadarObj.y_m(idx_obj, idx_data) = y_m - tmp_Length_m / 2 * tmp_Orientation_sin;
                elseif tmp_ReferencePoint == 6 %% Center of right
                    tmpRadarObj.Valid(idx_obj, idx_data) = 1;
                    tmpRadarObj.x_m(idx_obj, idx_data) = x_m - tmp_Width_m / 2 * tmp_Orientation_sin;
                    tmpRadarObj.y_m(idx_obj, idx_data) = y_m + tmp_Width_m / 2 * tmp_Orientation_cos;
                elseif tmp_ReferencePoint == 7 %% Center of rear
                    tmpRadarObj.Valid(idx_obj, idx_data) = 1;
                    tmpRadarObj.x_m(idx_obj, idx_data) = x_m + tmp_Length_m / 2 * tmp_Orientation_cos;
                    tmpRadarObj.y_m(idx_obj, idx_data) = y_m + tmp_Length_m / 2 * tmp_Orientation_sin;
                elseif tmp_ReferencePoint == 8 %% Center of left
                    tmpRadarObj.Valid(idx_obj, idx_data) = 1;
                    tmpRadarObj.x_m(idx_obj, idx_data) = x_m + tmp_Width_m / 2 * tmp_Orientation_sin;
                    tmpRadarObj.y_m(idx_obj, idx_data) = y_m - tmp_Width_m / 2 * tmp_Orientation_cos;
                elseif tmp_ReferencePoint == 9 %% Center of box
                    tmpRadarObj.Valid(idx_obj, idx_data) = 1;
                    tmpRadarObj.x_m(idx_obj, idx_data) = x_m;
                    tmpRadarObj.y_m(idx_obj, idx_data) = y_m;
                elseif tmp_ReferencePoint == 15 %% Invalid
                    tmpRadarObj.Valid(idx_obj, idx_data) = 0;
                end

                if tmpRadarObj.Valid(idx_obj, idx_data) == 1
                    tmpRadarObj.Object_ID(idx_obj, idx_data) = tmp_Object_ID(idx_obj, idx_data);
                else
                    tmpRadarObj.Object_ID(idx_obj, idx_data) = 0;
                end
            end
        end
    end

    RadarObj.Object_ID = tmpRadarObj.Object_ID(:,idxUnique);
    RadarObj.Orientation_rad = tmpRadarObj.Orientation_rad(:,idxUnique);
    RadarObj.Length_m = tmpRadarObj.Length_m(:,idxUnique);
    RadarObj.Width_m = tmpRadarObj.Width_m(:,idxUnique);
    RadarObj.x_m = tmpRadarObj.x_m(:,idxUnique);
    RadarObj.y_m = tmpRadarObj.y_m(:,idxUnique);
    RadarObj.Valid = tmpRadarObj.Valid(:,idxUnique);
    
    object_containers_map = containers.Map;
    for t = 1:size(RadarObj.Object_ID,2)
        time = UTCTime(t);
        id = RadarObj.Object_ID(:,t);
        [unique_id, ia, ic] = unique(id);
        for i = 1:length(unique_id)
            if unique_id(i) ~= 0                 
                pos_x = RadarObj.x_m(ia(i),t);
                pos_y = RadarObj.y_m(ia(i),t);
                len = RadarObj.Length_m(ia(i),t);
                width = RadarObj.Width_m(ia(i),t);
                heading_angle_rad = RadarObj.Orientation_rad(ia(i),t);

                if isKey(object_containers_map,num2str(unique_id(i))) == 1
                    % existing id
                    obj = object_containers_map(num2str(unique_id(i)));

                    % add data
                    object_containers_map(num2str(unique_id(i))) = obj.add_data(time, pos_x, pos_y, heading_angle_rad, width, len);
                else
                    % new id
                    obj = object_class(unique_id(i));
                    obj = obj.add_data(time, pos_x, pos_y, heading_angle_rad, width, len);

                    % register new key
                    object_containers_map(num2str(unique_id(i))) = obj;
                end            
            end
        end
        disp(t)
    end
end