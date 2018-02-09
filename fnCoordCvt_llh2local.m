function [ X_local, Y_local ] = fnCoordCvt_llh2local( EgoEnu, EgoHead, TargetEnu, TargetHead )
    % from enu to ego vehicle coordinate
    for Erridx = 1 : 1: length(EgoHead)
        % Reference targe tvehicle position estimation
        RotMat = [cosd(-EgoHead(Erridx)) -sind(-EgoHead(Erridx));
            sind(-EgoHead(Erridx)) cosd(-EgoHead(Erridx))];

        tmp_CurrentPos = [TargetEnu(Erridx, 1) TargetEnu(Erridx, 2)]';
        tmp_CurrentPos_VehCoord = RotMat*tmp_CurrentPos;

        % Distance difference between ego and target vehicle
        EastErr(Erridx, 1) = (TargetEnu(Erridx, 1)) - EgoEnu(1);
        NorthErr(Erridx, 1) = (TargetEnu(Erridx, 2)) - EgoEnu(2) ;

        % Heading difference between ego and target vehicle
        HeadingDiff(Erridx, 1) = TargetHead(Erridx) - EgoHead(1); % [deg]

        % Target vehicle position respect to ego vehicle coordinate
        X_local(Erridx, 1) = tmp_CurrentPos_VehCoord(1);
        Y_local(Erridx, 1) = tmp_CurrentPos_VehCoord(2);
    end
end

