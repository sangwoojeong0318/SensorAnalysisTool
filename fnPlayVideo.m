function fnPlayVideo( EgoVehicle, TargetVehicle, Object)
    for idxFrame = 1:1:size(EgoVehicle.enu, 1)
        plot(EgoVehicle.enu(idxFrame, 1), EgoVehicle.enu(idxFrame, 2), 'r.');
        plot(TargetVehicle.enu(idxFrame, 1), TargetVehicle.enu(idxFrame, 2), 'b.-');

        for idx = 1:1:size(Object.X_m, 1)
            ObjectEnu = fnCoordCvt_local2enu(EgoVehicle.enu(idxFrame, :), EgoVehicle.sig_State_Hdg(idxFrame), Object.X_m(idx,idxFrame), Object.Y_m(idx,idxFrame), Object.Valid(idx,idxFrame));
            plot(ObjectEnu(:,1), ObjectEnu(:,2), 'go');
        end
        pause(0.01);
    end
end

