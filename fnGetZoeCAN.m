function Zoe = fnGetZoeCAN(Logging_mat_path)
%UNTITLED 이 함수의 요약 설명 위치
%   자세한 설명 위치
load(Logging_mat_path);

Zoe_tmp.UTCTime = GPS_Type(:,1) * 10;
Zoe_tmp.CANTime = Time(:,1);
Zoe_tmp.Lat = sig_State_Lat(:,1);
Zoe_tmp.Lon = sig_State_Lon(:,1);
Zoe_tmp.Head = sig_State_Hdg(:,1);
Zoe_tmp.Vel_kph = VehicleSpeed(:,1);

Zoe.UTCTime(1) = Zoe_tmp.UTCTime(1);
Zoe.CANTime = Zoe_tmp.CANTime(1);
Zoe.Lat(1) = Zoe_tmp.Lat(1);
Zoe.Lon(1) = Zoe_tmp.Lon(1);
Zoe.Head(1) = Zoe_tmp.Head(1);
Zoe.Vel_kph(1) = Zoe_tmp.Vel_kph(1);

idxZoe = 1;
for idx = 2:1:size(Zoe_tmp.UTCTime,1)
    if(Zoe_tmp.UTCTime(idx) ~= Zoe_tmp.UTCTime(idx-1))
        idxZoe = idxZoe + 1;
        Zoe.UTCTime(idxZoe) = Zoe_tmp.UTCTime(idx);
        Zoe.CANTime(idxZoe) = Zoe_tmp.CANTime(idx);
        Zoe.Lat(idxZoe) = Zoe_tmp.Lat(idx);
        Zoe.Lon(idxZoe) = Zoe_tmp.Lon(idx);
        Zoe.Head(idxZoe) = Zoe_tmp.Head(idx);
        Zoe.Vel_kph(idxZoe) = Zoe_tmp.Vel_kph(idxZoe);
    end
end

Stereo.CANTime = Time(:,1);
rad2deg = 180.0 / 3.141592;



% tmp_StereoErrList.NumofObj = Result.AssoObj.Valid';
% tmp_StereoErrList.nID = Result.AssoObj.ID';
% tmp_StereoErrList.nAge = Result.AssoObj.Valid';
% tmp_StereoErrList.nType = Result.AssoObj.Valid';
% tmp_StereoErrList.Valid = Result.AssoObj.Valid';
% tmp_StereoErrList.PosX = Result.AssoObj.X';
% tmp_StereoErrList.PosY = Result.AssoObj.Y';
% tmp_StereoErrList.Vx = Result.AssoObj.Valid';
% tmp_StereoErrList.Width = Result.AssoObj.Valid';
% tmp_StereoErrList.Length = Result.AssoObj.Valid';



idxObj = 1;
mps2kph = 3.6;

Stereo.Obj.ID(idxObj,:) = Obj_ID_1(:,1);
Stereo.Obj.X(idxObj,:) = Object_x_1(:,1);
Stereo.Obj.Y(idxObj,:) = Object_y_1(:,1);
Stereo.Obj.mid_X(idxObj,:) = Obj_mid_x_1(:,1);
Stereo.Obj.mid_Y(idxObj,:) = Obj_mid_y_1(:,1);
Stereo.Obj.left_X(idxObj,:) = Obj_left_x_1(:,1);
Stereo.Obj.left_Y(idxObj,:) = Obj_left_y_1(:,1);
Stereo.Obj.right_X(idxObj,:) = Obj_right_x_1(:,1);
Stereo.Obj.right_Y(idxObj,:) = Obj_right_y_1(:,1);
Stereo.Obj.heading(idxObj,:) = Object_phi_1(:,1) * rad2deg;
Stereo.Obj.Vel(idxObj,:) = Object_V_1(:,1) * mps2kph;
% % Stereo.Obj.age(idxObj,:)

idxObj = 2;
Stereo.Obj.ID(idxObj,:) = Obj_ID_2(:,1);
Stereo.Obj.X(idxObj,:) = Object_x_2(:,1);
Stereo.Obj.Y(idxObj,:) = Object_y_2(:,1);
Stereo.Obj.mid_X(idxObj,:) = Obj_mid_x_2(:,1);
Stereo.Obj.mid_Y(idxObj,:) = Obj_mid_y_2(:,1);
Stereo.Obj.left_X(idxObj,:) = Obj_left_x_2(:,1);
Stereo.Obj.left_Y(idxObj,:) = Obj_left_y_2(:,1);
Stereo.Obj.right_X(idxObj,:) = Obj_right_x_2(:,1);
Stereo.Obj.right_Y(idxObj,:) = Obj_right_y_2(:,1);
Stereo.Obj.heading(idxObj,:) = Object_phi_2(:,1) * rad2deg;
Stereo.Obj.Vel(idxObj,:) = Object_V_2(:,1) * mps2kph;

idxObj = 3;
Stereo.Obj.ID(idxObj,:) = Obj_ID_3(:,1);
Stereo.Obj.X(idxObj,:) = Object_x_3(:,1);
Stereo.Obj.Y(idxObj,:) = Object_y_3(:,1);
Stereo.Obj.mid_X(idxObj,:) = Obj_mid_x_3(:,1);
Stereo.Obj.mid_Y(idxObj,:) = Obj_mid_y_3(:,1);
Stereo.Obj.left_X(idxObj,:) = Obj_left_x_3(:,1);
Stereo.Obj.left_Y(idxObj,:) = Obj_left_y_3(:,1);
Stereo.Obj.right_X(idxObj,:) = Obj_right_x_3(:,1);
Stereo.Obj.right_Y(idxObj,:) = Obj_right_y_3(:,1);
Stereo.Obj.heading(idxObj,:) = Object_phi_3(:,1) * rad2deg;
Stereo.Obj.Vel(idxObj,:) = Object_V_3(:,1) * mps2kph;

idxObj = 4;
Stereo.Obj.ID(idxObj, :) = Obj_ID_4(:,1);
Stereo.Obj.X(idxObj, :) = Object_x_4(:,1);
Stereo.Obj.Y(idxObj, :) = Object_y_4(:,1);
Stereo.Obj.mid_X(idxObj, :) = Obj_mid_x_4(:,1);
Stereo.Obj.mid_Y(idxObj, :) = Obj_mid_y_4(:,1);
Stereo.Obj.left_X(idxObj, :) = Obj_left_x_4(:,1);
Stereo.Obj.left_Y(idxObj, :) = Obj_left_y_4(:,1);
Stereo.Obj.right_X(idxObj, :) = Obj_right_x_4(:,1);
Stereo.Obj.right_Y(idxObj, :) = Obj_right_y_4(:,1);
Stereo.Obj.heading(idxObj, :) = Object_phi_4(:,1) * rad2deg;
Stereo.Obj.Vel(idxObj,:) = Object_V_4(:,1) * mps2kph;

idxObj = 5;
Stereo.Obj.ID(idxObj, :) = Obj_ID_5(:,1);
Stereo.Obj.X(idxObj, :) = Object_x_5(:,1);
Stereo.Obj.Y(idxObj, :) = Object_y_5(:,1);
Stereo.Obj.mid_X(idxObj, :) = Obj_mid_x_5(:,1);
Stereo.Obj.mid_Y(idxObj, :) = Obj_mid_y_5(:,1);
Stereo.Obj.left_X(idxObj, :) = Obj_left_x_5(:,1);
Stereo.Obj.left_Y(idxObj, :) = Obj_left_y_5(:,1);
Stereo.Obj.right_X(idxObj, :) = Obj_right_x_5(:,1);
Stereo.Obj.right_Y(idxObj, :) = Obj_right_y_5(:,1);
Stereo.Obj.heading(idxObj, :) = Object_phi_5(:,1) * rad2deg;
Stereo.Obj.Vel(idxObj,:) = Object_V_5(:,1) * mps2kph;

idxObj = 6;
Stereo.Obj.ID(idxObj, :) = Obj_ID_6(:,1);
Stereo.Obj.X(idxObj, :) = Object_x_6(:,1);
Stereo.Obj.Y(idxObj, :) = Object_y_6(:,1);
Stereo.Obj.mid_X(idxObj, :) = Obj_mid_x_6(:,1);
Stereo.Obj.mid_Y(idxObj, :) = Obj_mid_y_6(:,1);
Stereo.Obj.left_X(idxObj, :) = Obj_left_x_6(:,1);
Stereo.Obj.left_Y(idxObj, :) = Obj_left_y_6(:,1);
Stereo.Obj.right_X(idxObj, :) = Obj_right_x_6(:,1);
Stereo.Obj.right_Y(idxObj, :) = Obj_right_y_6(:,1);
Stereo.Obj.heading(idxObj, :) = Object_phi_6(:,1) * rad2deg;
Stereo.Obj.Vel(idxObj,:) = Object_V_6(:,1) * mps2kph;

idxObj = 7;
Stereo.Obj.ID(idxObj, :) = Obj_ID_7(:,1);
Stereo.Obj.X(idxObj, :) = Object_x_7(:,1);
Stereo.Obj.Y(idxObj, :) = Object_y_7(:,1);
Stereo.Obj.mid_X(idxObj, :) = Obj_mid_x_7(:,1);
Stereo.Obj.mid_Y(idxObj, :) = Obj_mid_y_7(:,1);
Stereo.Obj.left_X(idxObj, :) = Obj_left_x_7(:,1);
Stereo.Obj.left_Y(idxObj, :) = Obj_left_y_7(:,1);
Stereo.Obj.right_X(idxObj, :) = Obj_right_x_7(:,1);
Stereo.Obj.right_Y(idxObj, :) = Obj_right_y_7(:,1);
Stereo.Obj.heading(idxObj, :) = Object_phi_7(:,1) * rad2deg;
Stereo.Obj.Vel(idxObj,:) = Object_V_7(:,1) * mps2kph;

idxObj = 8;
Stereo.Obj.ID(idxObj, :) = Obj_ID_8(:,1);
Stereo.Obj.X(idxObj, :) = Object_x_8(:,1);
Stereo.Obj.Y(idxObj, :) = Object_y_8(:,1);
Stereo.Obj.mid_X(idxObj, :) = Obj_mid_x_8(:,1);
Stereo.Obj.mid_Y(idxObj, :) = Obj_mid_y_8(:,1);
Stereo.Obj.left_X(idxObj, :) = Obj_left_x_8(:,1);
Stereo.Obj.left_Y(idxObj, :) = Obj_left_y_8(:,1);
Stereo.Obj.right_X(idxObj, :) = Obj_right_x_8(:,1);
Stereo.Obj.right_Y(idxObj, :) = Obj_right_y_8(:,1);
Stereo.Obj.heading(idxObj, :) = Object_phi_8(:,1) * rad2deg;
Stereo.Obj.Vel(idxObj,:) = Object_V_8(:,1) * mps2kph;

idxObj = 9;
Stereo.Obj.ID(idxObj, :) = Obj_ID_9(:,1);
Stereo.Obj.X(idxObj, :) = Object_x_9(:,1);
Stereo.Obj.Y(idxObj, :) = Object_y_9(:,1);
Stereo.Obj.mid_X(idxObj, :) = Obj_mid_x_9(:,1);
Stereo.Obj.mid_Y(idxObj, :) = Obj_mid_y_9(:,1);
Stereo.Obj.left_X(idxObj, :) = Obj_left_x_9(:,1);
Stereo.Obj.left_Y(idxObj, :) = Obj_left_y_9(:,1);
Stereo.Obj.right_X(idxObj, :) = Obj_right_x_9(:,1);
Stereo.Obj.right_Y(idxObj, :) = Obj_right_y_9(:,1);
Stereo.Obj.heading(idxObj, :) = Object_phi_9(:,1) * rad2deg;
Stereo.Obj.Vel(idxObj,:) = Object_V_9(:,1) * mps2kph;

idxObj = 10;
Stereo.Obj.ID(idxObj, :) = Obj_ID_10(:,1);
Stereo.Obj.X(idxObj, :) = Object_x_10(:,1);
Stereo.Obj.Y(idxObj, :) = Object_y_10(:,1);
Stereo.Obj.mid_X(idxObj, :) = Obj_mid_x_10(:,1);
Stereo.Obj.mid_Y(idxObj, :) = Obj_mid_y_10(:,1);
Stereo.Obj.left_X(idxObj, :) = Obj_left_x_10(:,1);
Stereo.Obj.left_Y(idxObj, :) = Obj_left_y_10(:,1);
Stereo.Obj.right_X(idxObj, :) = Obj_right_x_10(:,1);
Stereo.Obj.right_Y(idxObj, :) = Obj_right_y_10(:,1);
Stereo.Obj.heading(idxObj, :) = Object_phi_10(:,1) * rad2deg;
Stereo.Obj.Vel(idxObj,:) = Object_V_10(:,1) * mps2kph;

idxObj = 11;
Stereo.Obj.ID(idxObj, :) = Obj_ID_11(:,1);
Stereo.Obj.X(idxObj, :) = Object_x_11(:,1);
Stereo.Obj.Y(idxObj, :) = Object_y_11(:,1);
Stereo.Obj.mid_X(idxObj, :) = Obj_mid_x_11(:,1);
Stereo.Obj.mid_Y(idxObj, :) = Obj_mid_y_11(:,1);
Stereo.Obj.left_X(idxObj, :) = Obj_left_x_11(:,1);
Stereo.Obj.left_Y(idxObj, :) = Obj_left_y_11(:,1);
Stereo.Obj.right_X(idxObj, :) = Obj_right_x_11(:,1);
Stereo.Obj.right_Y(idxObj, :) = Obj_right_y_11(:,1);
Stereo.Obj.heading(idxObj, :) = Object_phi_11(:,1) * rad2deg;
Stereo.Obj.Vel(idxObj,:) = Object_V_11(:,1) * mps2kph;

idxObj = 12;
Stereo.Obj.ID(idxObj, :) = Obj_ID_12(:,1);
Stereo.Obj.X(idxObj, :) = Object_x_12(:,1);
Stereo.Obj.Y(idxObj, :) = Object_y_12(:,1);
Stereo.Obj.mid_X(idxObj, :) = Obj_mid_x_12(:,1);
Stereo.Obj.mid_Y(idxObj, :) = Obj_mid_y_12(:,1);
Stereo.Obj.left_X(idxObj, :) = Obj_left_x_12(:,1);
Stereo.Obj.left_Y(idxObj, :) = Obj_left_y_12(:,1);
Stereo.Obj.right_X(idxObj, :) = Obj_right_x_12(:,1);
Stereo.Obj.right_Y(idxObj, :) = Obj_right_y_12(:,1);
Stereo.Obj.heading(idxObj, :) = Object_phi_12(:,1) * rad2deg;
Stereo.Obj.Vel(idxObj,:) = Object_V_12(:,1) * mps2kph;

idxSte_start = 1;
for idxZoe = 1:1:size(Zoe.CANTime,2)
    Timediff_min = 99999999;
    for idxSte = idxSte_start:1:size(Stereo.CANTime,1)
        Timediff = abs(Zoe.CANTime(idxZoe) - Stereo.CANTime(idxSte));
        if(Timediff < Timediff_min)
            Timediff_min = Timediff;
            Zoe.Obj.ID(:, idxZoe) = Stereo.Obj.ID(:, idxSte);
            Zoe.Obj.X(:, idxZoe) = Stereo.Obj.X(:, idxSte);
            Zoe.Obj.Y(:, idxZoe) = Stereo.Obj.Y(:, idxSte);
            Zoe.Obj.mid_X(:, idxZoe) = Stereo.Obj.mid_X(:, idxSte);
            Zoe.Obj.mid_Y(:, idxZoe) = Stereo.Obj.mid_Y(:, idxSte);
            Zoe.Obj.left_X(:, idxZoe) = Stereo.Obj.left_X(:, idxSte);
            Zoe.Obj.left_Y(:, idxZoe) = Stereo.Obj.left_Y(:, idxSte);
            Zoe.Obj.right_X(:, idxZoe) = Stereo.Obj.right_X(:, idxSte);
            Zoe.Obj.right_Y(:, idxZoe) = Stereo.Obj.right_Y(:, idxSte);
            Zoe.Obj.heading(:, idxZoe) = Stereo.Obj.heading(:, idxSte);
            Zoe.Obj.Vel_kph(:, idxZoe) = Stereo.Obj.Vel(:, idxSte);
        else
            idxSte_start = idxSte-1;
            if idxSte_start < 1
                idxSte_start = 1;
            end
            break;
        end
    end
end

end

