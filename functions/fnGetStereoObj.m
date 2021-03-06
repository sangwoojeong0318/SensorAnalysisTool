function object_containers_map = fnGetStereoObj( CAN_raw )
% Filtering 중복된 데이터
UTCTime = CAN_raw.GPS_Type(:,1) * 10;
[tmpSpace, idxUnique] = unique(UTCTime);
idxUnique = idxUnique(tmpSpace ~= 0);
UTCTime = tmpSpace(tmpSpace ~= 0);

% Get stereo info
rad2deg = 180.0 / 3.141592;

idxObj = 1;
mps2kph = 3.6;

StereoObj.Object_ID(idxObj,:) = CAN_raw.Obj_ID_1(idxUnique);
StereoObj.x_m(idxObj,:) = CAN_raw.Object_x_1(idxUnique);
StereoObj.y_m(idxObj,:) = CAN_raw.Object_y_1(idxUnique);
StereoObj.mid_X(idxObj,:) = CAN_raw.Obj_mid_x_1(idxUnique);
StereoObj.mid_Y(idxObj,:) = CAN_raw.Obj_mid_y_1(idxUnique);
StereoObj.left_X(idxObj,:) = CAN_raw.Obj_left_x_1(idxUnique);
StereoObj.left_Y(idxObj,:) = CAN_raw.Obj_left_y_1(idxUnique);
StereoObj.right_X(idxObj,:) = CAN_raw.Obj_right_x_1(idxUnique);
StereoObj.right_Y(idxObj,:) = CAN_raw.Obj_right_y_1(idxUnique);
StereoObj.Orientation_rad(idxObj,:) = CAN_raw.Object_phi_1(idxUnique) * rad2deg;
StereoObj.Vel(idxObj,:) = CAN_raw.Object_V_1(idxUnique) * mps2kph;
StereoObj.Valid(idxObj, :) = StereoObj.Object_ID(idxObj,:) ~= 0;
% % StereoObj.age(idxObj,:)

idxObj = 2;
StereoObj.Object_ID(idxObj,:) = CAN_raw.Obj_ID_2(idxUnique);
StereoObj.x_m(idxObj,:) = CAN_raw.Object_x_2(idxUnique);
StereoObj.y_m(idxObj,:) = CAN_raw.Object_y_2(idxUnique);
StereoObj.mid_X(idxObj,:) = CAN_raw.Obj_mid_x_2(idxUnique);
StereoObj.mid_Y(idxObj,:) = CAN_raw.Obj_mid_y_2(idxUnique);
StereoObj.left_X(idxObj,:) = CAN_raw.Obj_left_x_2(idxUnique);
StereoObj.left_Y(idxObj,:) = CAN_raw.Obj_left_y_2(idxUnique);
StereoObj.right_X(idxObj,:) = CAN_raw.Obj_right_x_2(idxUnique);
StereoObj.right_Y(idxObj,:) = CAN_raw.Obj_right_y_2(idxUnique);
StereoObj.Orientation_rad(idxObj,:) = CAN_raw.Object_phi_2(idxUnique) * rad2deg;
StereoObj.Vel(idxObj,:) = CAN_raw.Object_V_2(idxUnique) * mps2kph;
StereoObj.Valid(idxObj, :) = StereoObj.Object_ID(idxObj,:) ~= 0;

idxObj = 3;
StereoObj.Object_ID(idxObj,:) = CAN_raw.Obj_ID_3(idxUnique);
StereoObj.x_m(idxObj,:) = CAN_raw.Object_x_3(idxUnique);
StereoObj.y_m(idxObj,:) = CAN_raw.Object_y_3(idxUnique);
StereoObj.mid_X(idxObj,:) = CAN_raw.Obj_mid_x_3(idxUnique);
StereoObj.mid_Y(idxObj,:) = CAN_raw.Obj_mid_y_3(idxUnique);
StereoObj.left_X(idxObj,:) = CAN_raw.Obj_left_x_3(idxUnique);
StereoObj.left_Y(idxObj,:) = CAN_raw.Obj_left_y_3(idxUnique);
StereoObj.right_X(idxObj,:) = CAN_raw.Obj_right_x_3(idxUnique);
StereoObj.right_Y(idxObj,:) = CAN_raw.Obj_right_y_3(idxUnique);
StereoObj.Orientation_rad(idxObj,:) = CAN_raw.Object_phi_3(idxUnique) * rad2deg;
StereoObj.Vel(idxObj,:) = CAN_raw.Object_V_3(idxUnique) * mps2kph;
StereoObj.Valid(idxObj, :) = StereoObj.Object_ID(idxObj,:) ~= 0;

idxObj = 4;
StereoObj.Object_ID(idxObj, :) = CAN_raw.Obj_ID_4(idxUnique);
StereoObj.x_m(idxObj, :) = CAN_raw.Object_x_4(idxUnique);
StereoObj.y_m(idxObj, :) = CAN_raw.Object_y_4(idxUnique);
StereoObj.mid_X(idxObj, :) = CAN_raw.Obj_mid_x_4(idxUnique);
StereoObj.mid_Y(idxObj, :) = CAN_raw.Obj_mid_y_4(idxUnique);
StereoObj.left_X(idxObj, :) = CAN_raw.Obj_left_x_4(idxUnique);
StereoObj.left_Y(idxObj, :) = CAN_raw.Obj_left_y_4(idxUnique);
StereoObj.right_X(idxObj, :) = CAN_raw.Obj_right_x_4(idxUnique);
StereoObj.right_Y(idxObj, :) = CAN_raw.Obj_right_y_4(idxUnique);
StereoObj.Orientation_rad(idxObj, :) = CAN_raw.Object_phi_4(idxUnique) * rad2deg;
StereoObj.Vel(idxObj,:) = CAN_raw.Object_V_4(idxUnique) * mps2kph;
StereoObj.Valid(idxObj, :) = StereoObj.Object_ID(idxObj,:) ~= 0;

idxObj = 5;
StereoObj.Object_ID(idxObj, :) = CAN_raw.Obj_ID_5(idxUnique);
StereoObj.x_m(idxObj, :) = CAN_raw.Object_x_5(idxUnique);
StereoObj.y_m(idxObj, :) = CAN_raw.Object_y_5(idxUnique);
StereoObj.mid_X(idxObj, :) = CAN_raw.Obj_mid_x_5(idxUnique);
StereoObj.mid_Y(idxObj, :) = CAN_raw.Obj_mid_y_5(idxUnique);
StereoObj.left_X(idxObj, :) = CAN_raw.Obj_left_x_5(idxUnique);
StereoObj.left_Y(idxObj, :) = CAN_raw.Obj_left_y_5(idxUnique);
StereoObj.right_X(idxObj, :) = CAN_raw.Obj_right_x_5(idxUnique);
StereoObj.right_Y(idxObj, :) = CAN_raw.Obj_right_y_5(idxUnique);
StereoObj.Orientation_rad(idxObj, :) = CAN_raw.Object_phi_5(idxUnique) * rad2deg;
StereoObj.Vel(idxObj,:) = CAN_raw.Object_V_5(idxUnique) * mps2kph;
StereoObj.Valid(idxObj, :) = StereoObj.Object_ID(idxObj,:) ~= 0;

idxObj = 6;
StereoObj.Object_ID(idxObj, :) = CAN_raw.Obj_ID_6(idxUnique);
StereoObj.x_m(idxObj, :) = CAN_raw.Object_x_6(idxUnique);
StereoObj.y_m(idxObj, :) = CAN_raw.Object_y_6(idxUnique);
StereoObj.mid_X(idxObj, :) = CAN_raw.Obj_mid_x_6(idxUnique);
StereoObj.mid_Y(idxObj, :) = CAN_raw.Obj_mid_y_6(idxUnique);
StereoObj.left_X(idxObj, :) = CAN_raw.Obj_left_x_6(idxUnique);
StereoObj.left_Y(idxObj, :) = CAN_raw.Obj_left_y_6(idxUnique);
StereoObj.right_X(idxObj, :) = CAN_raw.Obj_right_x_6(idxUnique);
StereoObj.right_Y(idxObj, :) = CAN_raw.Obj_right_y_6(idxUnique);
StereoObj.Orientation_rad(idxObj, :) = CAN_raw.Object_phi_6(idxUnique) * rad2deg;
StereoObj.Vel(idxObj,:) = CAN_raw.Object_V_6(idxUnique) * mps2kph;
StereoObj.Valid(idxObj, :) = StereoObj.Object_ID(idxObj,:) ~= 0;

idxObj = 7;
StereoObj.Object_ID(idxObj, :) = CAN_raw.Obj_ID_7(idxUnique);
StereoObj.x_m(idxObj, :) = CAN_raw.Object_x_7(idxUnique);
StereoObj.y_m(idxObj, :) = CAN_raw.Object_y_7(idxUnique);
StereoObj.mid_X(idxObj, :) = CAN_raw.Obj_mid_x_7(idxUnique);
StereoObj.mid_Y(idxObj, :) = CAN_raw.Obj_mid_y_7(idxUnique);
StereoObj.left_X(idxObj, :) = CAN_raw.Obj_left_x_7(idxUnique);
StereoObj.left_Y(idxObj, :) = CAN_raw.Obj_left_y_7(idxUnique);
StereoObj.right_X(idxObj, :) = CAN_raw.Obj_right_x_7(idxUnique);
StereoObj.right_Y(idxObj, :) = CAN_raw.Obj_right_y_7(idxUnique);
StereoObj.Orientation_rad(idxObj, :) = CAN_raw.Object_phi_7(idxUnique) * rad2deg;
StereoObj.Vel(idxObj,:) = CAN_raw.Object_V_7(idxUnique) * mps2kph;
StereoObj.Valid(idxObj, :) = StereoObj.Object_ID(idxObj,:) ~= 0;

idxObj = 8;
StereoObj.Object_ID(idxObj, :) = CAN_raw.Obj_ID_8(idxUnique);
StereoObj.x_m(idxObj, :) = CAN_raw.Object_x_8(idxUnique);
StereoObj.y_m(idxObj, :) = CAN_raw.Object_y_8(idxUnique);
StereoObj.mid_X(idxObj, :) = CAN_raw.Obj_mid_x_8(idxUnique);
StereoObj.mid_Y(idxObj, :) = CAN_raw.Obj_mid_y_8(idxUnique);
StereoObj.left_X(idxObj, :) = CAN_raw.Obj_left_x_8(idxUnique);
StereoObj.left_Y(idxObj, :) = CAN_raw.Obj_left_y_8(idxUnique);
StereoObj.right_X(idxObj, :) = CAN_raw.Obj_right_x_8(idxUnique);
StereoObj.right_Y(idxObj, :) = CAN_raw.Obj_right_y_8(idxUnique);
StereoObj.Orientation_rad(idxObj, :) = CAN_raw.Object_phi_8(idxUnique) * rad2deg;
StereoObj.Vel(idxObj,:) = CAN_raw.Object_V_8(idxUnique) * mps2kph;
StereoObj.Valid(idxObj, :) = StereoObj.Object_ID(idxObj,:) ~= 0;

idxObj = 9;
StereoObj.Object_ID(idxObj, :) = CAN_raw.Obj_ID_9(idxUnique);
StereoObj.x_m(idxObj, :) = CAN_raw.Object_x_9(idxUnique);
StereoObj.y_m(idxObj, :) = CAN_raw.Object_y_9(idxUnique);
StereoObj.mid_X(idxObj, :) = CAN_raw.Obj_mid_x_9(idxUnique);
StereoObj.mid_Y(idxObj, :) = CAN_raw.Obj_mid_y_9(idxUnique);
StereoObj.left_X(idxObj, :) = CAN_raw.Obj_left_x_9(idxUnique);
StereoObj.left_Y(idxObj, :) = CAN_raw.Obj_left_y_9(idxUnique);
StereoObj.right_X(idxObj, :) = CAN_raw.Obj_right_x_9(idxUnique);
StereoObj.right_Y(idxObj, :) = CAN_raw.Obj_right_y_9(idxUnique);
StereoObj.Orientation_rad(idxObj, :) = CAN_raw.Object_phi_9(idxUnique) * rad2deg;
StereoObj.Vel(idxObj,:) = CAN_raw.Object_V_9(idxUnique) * mps2kph;
StereoObj.Valid(idxObj, :) = StereoObj.Object_ID(idxObj,:) ~= 0;

idxObj = 10;
StereoObj.Object_ID(idxObj, :) = CAN_raw.Obj_ID_10(idxUnique);
StereoObj.x_m(idxObj, :) = CAN_raw.Object_x_10(idxUnique);
StereoObj.y_m(idxObj, :) = CAN_raw.Object_y_10(idxUnique);
StereoObj.mid_X(idxObj, :) = CAN_raw.Obj_mid_x_10(idxUnique);
StereoObj.mid_Y(idxObj, :) = CAN_raw.Obj_mid_y_10(idxUnique);
StereoObj.left_X(idxObj, :) = CAN_raw.Obj_left_x_10(idxUnique);
StereoObj.left_Y(idxObj, :) = CAN_raw.Obj_left_y_10(idxUnique);
StereoObj.right_X(idxObj, :) = CAN_raw.Obj_right_x_10(idxUnique);
StereoObj.right_Y(idxObj, :) = CAN_raw.Obj_right_y_10(idxUnique);
StereoObj.Orientation_rad(idxObj, :) = CAN_raw.Object_phi_10(idxUnique) * rad2deg;
StereoObj.Vel(idxObj,:) = CAN_raw.Object_V_10(idxUnique) * mps2kph;
StereoObj.Valid(idxObj, :) = StereoObj.Object_ID(idxObj,:) ~= 0;

idxObj = 11;
StereoObj.Object_ID(idxObj, :) = CAN_raw.Obj_ID_11(idxUnique);
StereoObj.x_m(idxObj, :) = CAN_raw.Object_x_11(idxUnique);
StereoObj.y_m(idxObj, :) = CAN_raw.Object_y_11(idxUnique);
StereoObj.mid_X(idxObj, :) = CAN_raw.Obj_mid_x_11(idxUnique);
StereoObj.mid_Y(idxObj, :) = CAN_raw.Obj_mid_y_11(idxUnique);
StereoObj.left_X(idxObj, :) = CAN_raw.Obj_left_x_11(idxUnique);
StereoObj.left_Y(idxObj, :) = CAN_raw.Obj_left_y_11(idxUnique);
StereoObj.right_X(idxObj, :) = CAN_raw.Obj_right_x_11(idxUnique);
StereoObj.right_Y(idxObj, :) = CAN_raw.Obj_right_y_11(idxUnique);
StereoObj.Orientation_rad(idxObj, :) = CAN_raw.Object_phi_11(idxUnique) * rad2deg;
StereoObj.Vel(idxObj,:) = CAN_raw.Object_V_11(idxUnique) * mps2kph;
StereoObj.Valid(idxObj, :) = StereoObj.Object_ID(idxObj,:) ~= 0;

idxObj = 12;
StereoObj.Object_ID(idxObj, :) = CAN_raw.Obj_ID_12(idxUnique);
StereoObj.x_m(idxObj, :) = CAN_raw.Object_x_12(idxUnique);
StereoObj.y_m(idxObj, :) = CAN_raw.Object_y_12(idxUnique);
StereoObj.mid_X(idxObj, :) = CAN_raw.Obj_mid_x_12(idxUnique);
StereoObj.mid_Y(idxObj, :) = CAN_raw.Obj_mid_y_12(idxUnique);
StereoObj.left_X(idxObj, :) = CAN_raw.Obj_left_x_12(idxUnique);
StereoObj.left_Y(idxObj, :) = CAN_raw.Obj_left_y_12(idxUnique);
StereoObj.right_X(idxObj, :) = CAN_raw.Obj_right_x_12(idxUnique);
StereoObj.right_Y(idxObj, :) = CAN_raw.Obj_right_y_12(idxUnique);
StereoObj.Orientation_rad(idxObj, :) = CAN_raw.Object_phi_12(idxUnique);
StereoObj.Vel(idxObj,:) = CAN_raw.Object_V_12(idxUnique) * mps2kph;
StereoObj.Valid(idxObj, :) = StereoObj.Object_ID(idxObj,:) ~= 0;

% make container
object_containers_map = containers.Map;
for t = 1:size(StereoObj.Object_ID,2)
    time = UTCTime(t);
    id = StereoObj.Object_ID(:,t);
    [unique_id, ia, ic] = unique(id);
    for i = 1:length(unique_id)
        if unique_id(i) ~= 0                 
            pos_x = StereoObj.x_m(ia(i),t);
            pos_y = StereoObj.y_m(ia(i),t);
            len = StereoObj.left_X(ia(i),t);
            width = StereoObj.left_Y(ia(i),t);
            heading_angle_rad = StereoObj.Orientation_rad(ia(i),t);

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
%         disp(t)
end

% 
% idxSte_start = 1;
% for idxZoe = 1:1:size(Zoe.CANTime,2)
%     Timediff_min = 99999999;
%     for idxSte = idxSte_start:1:size(Stereo.CANTime,1)
%         Timediff = abs(Zoe.CANTime(idxZoe) - Stereo.CANTime(idxSte));
%         if(Timediff < Timediff_min)
%             Timediff_min = Timediff;
%             Zoe.Obj.Object_ID(:, idxZoe) = StereoObj.Object_ID(:, idxSte);
%             Zoe.Obj.x_m(:, idxZoe) = StereoObj.x_m(:, idxSte);
%             Zoe.Obj.y_m(:, idxZoe) = StereoObj.y_m(:, idxSte);
%             Zoe.Obj.mid_X(:, idxZoe) = StereoObj.mid_X(:, idxSte);
%             Zoe.Obj.mid_Y(:, idxZoe) = StereoObj.mid_Y(:, idxSte);
%             Zoe.Obj.left_X(:, idxZoe) = StereoObj.left_X(:, idxSte);
%             Zoe.Obj.left_Y(:, idxZoe) = StereoObj.left_Y(:, idxSte);
%             Zoe.Obj.right_X(:, idxZoe) = StereoObj.right_X(:, idxSte);
%             Zoe.Obj.right_Y(:, idxZoe) = StereoObj.right_Y(:, idxSte);
%             Zoe.Obj.Orientation_rad(:, idxZoe) = StereoObj.Orientation_rad(:, idxSte);
%             Zoe.Obj.Vel_kph(:, idxZoe) = StereoObj.Vel(:, idxSte);
%         else
%             idxSte_start = idxSte-1;
%             if idxSte_start < 1
%                 idxSte_start = 1;
%             end
%             break;
%         end
%     end
% end
end

