function FilteredObj = fnGetSynchedObj( RefTime, RefX, RefY, ObjInfo )  
Keys = ObjInfo.keys;
PrevTimeIdx = ones(size(Keys));
AssoTimeIdx = ones(size(Keys));

for idxSynch = 1:1:length(RefTime)
    mindist = 99999; ID = 0; Valid = 0; X_m = 0; Y_m = 0;
    for idxKey = 1:1:length(Keys)
        for idxTime = PrevTimeIdx(idxKey):1:length(ObjInfo(char(Keys(idxKey))).time)
            ObjTime = ObjInfo(char(Keys(idxKey))).time(idxTime);

            if(ObjTime > RefTime(idxSynch))
                AssoTimeIdx(idxKey) = max(1, idxTime);
                break;
            end

            if(RefTime(idxSynch) == ObjTime)
                dist = sqrt((ObjInfo(char(Keys(idxKey))).pos_x_m(idxTime,2) - RefX(idxSynch))^2 + ...
                    (ObjInfo(char(Keys(idxKey))).pos_y_m(idxTime,2) - RefY(idxSynch))^2);
                if(dist < mindist && dist < 5)
                    ID = ObjInfo(char(Keys(idxKey))).id;
                    Valid = 1;
                    X_m = ObjInfo(char(Keys(idxKey))).pos_x_m(idxTime,2);
                    Y_m = ObjInfo(char(Keys(idxKey))).pos_y_m(idxTime,2);
                    AssoTimeIdx(idxKey) = idxTime;
                    mindist = dist;
                end
            end
        end
    end

    PrevTimeIdx = AssoTimeIdx;
    FilteredObj.ID(idxSynch) = ID;
    FilteredObj.Valid(idxSynch) = Valid;
    FilteredObj.X_m(idxSynch) = X_m;
    FilteredObj.Y_m(idxSynch) = Y_m;
    FilteredObj.Dist_m(idxSynch) = mindist;
end
%     Object.Stereo.ID = StereoObj.ID(:, Synched_CAN_Idx);
%     Object.Stereo.Valid = StereoObj.Valid(:, Synched_CAN_Idx);
%     Object.Stereo.X_m = StereoObj.X(:, Synched_CAN_Idx);
%     Object.Stereo.Y_m = StereoObj.Y(:, Synched_CAN_Idx);
%     Object.Stereo.X_mid_m = StereoObj.mid_X(:, Synched_CAN_Idx);
%     Object.Stereo.Y_mid_m = StereoObj.mid_Y(:, Synched_CAN_Idx);
%     Object.Stereo.X_left_m = StereoObj.left_X(:, Synched_CAN_Idx);
%     Object.Stereo.Y_left_m = StereoObj.left_Y(:, Synched_CAN_Idx);
%     Object.Stereo.X_right_m = StereoObj.right_X(:, Synched_CAN_Idx);
%     Object.Stereo.Y_right_m = StereoObj.right_Y(:, Synched_CAN_Idx);


end

