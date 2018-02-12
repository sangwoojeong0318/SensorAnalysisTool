function [ Synched_Idx1, Synched_Idx2 ] = fnSynchronizer( UTCTime_1, UTCTime_2)
nValue_1 = size(UTCTime_1);
nValue_2 = size(UTCTime_2);

idxValue_2_start = 1;
idxRes = 0;
for idxValue_1 = 1:1:nValue_1   
    for idxValue_2 = idxValue_2_start:1:nValue_2
        if(UTCTime_1(idxValue_1) == UTCTime_2(idxValue_2))
            % A1과 Zoe 시간 일치
            idxRes = idxRes + 1;
            Synched_Idx1(idxRes) = idxValue_1;
            Synched_Idx2(idxRes) = idxValue_2;
            break;
        end
    end
end
end

