function TargetEnu = fnCoordCvt_local2enu( EgoEnu, EgoHead, TargetX, TargetY, TargetValid )
e = 0; n = 0; u = 0;
idxValid = 0;
for idx = 1:1:length(EgoHead)
    if TargetX(idx) ~= 0 && TargetY(idx) ~= 0 && TargetValid(idx) == 1
        RotMat = [cosd(-EgoHead(idx)) sind(-EgoHead(idx));
            -sind(-EgoHead(idx)) cosd(-EgoHead(idx))];
        tmpXY = RotMat * [TargetX(idx);TargetY(idx)];

        idxValid = idxValid + 1;
        e(idxValid) = tmpXY(1) + EgoEnu(idx, 1);
        n(idxValid) = tmpXY(2) + EgoEnu(idx, 2);
        u(idxValid) = 0;
    end
end

TargetEnu = [e;n;u]';

end

