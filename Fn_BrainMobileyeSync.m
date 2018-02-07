function Mobileye = Fn_BrainMobileyeSync( BrainFlexRayFrames, Mobileye_DataFrames )
%%  File Name: Fn_BrainMobileyeSync.m
%  Description: Brain Mobileye Synchronizaion
%  Author: Wooyoung Lee
%  Copyright(C) 2017 ACE Lab, All Right Reserved.
% *************************************************************************

%% Data type define
meyeSyncIdx = 1;
%% Synchronization
fprintf('  - Sync the Mobileye exported data ...      ');

for BrainSyncIdx = 1 : (length(BrainFlexRayFrames.Time)-1)
    if (BrainFlexRayFrames.Time(BrainSyncIdx) <= Mobileye_DataFrames.Time(meyeSyncIdx))...
            &&(BrainFlexRayFrames.Time(BrainSyncIdx+1) >= Mobileye_DataFrames.Time(meyeSyncIdx))

        Mobileye.Time(BrainSyncIdx, 1) = Mobileye_DataFrames.Time(meyeSyncIdx);
        Mobileye.DataSize(BrainSyncIdx, 1) = Mobileye_DataFrames.DataSize(meyeSyncIdx);

        for nObjIdx = 1:1:Mobileye_DataFrames.MaxNumofObject(meyeSyncIdx, 1)
            Mobileye.DynObjList(BrainSyncIdx, nObjIdx).nID = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).nID;
            Mobileye.DynObjList(BrainSyncIdx, nObjIdx).nAge = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).nAge;
            Mobileye.DynObjList(BrainSyncIdx, nObjIdx).Type = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).Type;
            Mobileye.DynObjList(BrainSyncIdx, nObjIdx).Valid = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).Valid;
            Mobileye.DynObjList(BrainSyncIdx, nObjIdx).X_m = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).X_m;
            Mobileye.DynObjList(BrainSyncIdx, nObjIdx).Y_m = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).Y_m;
            Mobileye.DynObjList(BrainSyncIdx, nObjIdx).Vx_mps = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).Vx_mps;
            Mobileye.DynObjList(BrainSyncIdx, nObjIdx).Yaw_deg = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).Yaw_deg;
            Mobileye.DynObjList(BrainSyncIdx, nObjIdx).Width_m = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).Width_m;
            Mobileye.DynObjList(BrainSyncIdx, nObjIdx).Length_m = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).Length_m;
        end

    else
        Mobileye.Time(BrainSyncIdx, 1) = Mobileye_DataFrames.Time(meyeSyncIdx);
        Mobileye.DataSize(BrainSyncIdx, 1) = Mobileye_DataFrames.DataSize(meyeSyncIdx);

        for nObjIdx = 1:1:Mobileye_DataFrames.MaxNumofObject(meyeSyncIdx, 1)
            Mobileye.DynObjList(BrainSyncIdx, nObjIdx).nID = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).nID;
            Mobileye.DynObjList(BrainSyncIdx, nObjIdx).nAge = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).nAge;
            Mobileye.DynObjList(BrainSyncIdx, nObjIdx).Type = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).Type;
            Mobileye.DynObjList(BrainSyncIdx, nObjIdx).Valid = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).Valid;
            Mobileye.DynObjList(BrainSyncIdx, nObjIdx).X_m = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).X_m;
            Mobileye.DynObjList(BrainSyncIdx, nObjIdx).Y_m = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).Y_m;
            Mobileye.DynObjList(BrainSyncIdx, nObjIdx).Vx_mps = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).Vx_mps;
            Mobileye.DynObjList(BrainSyncIdx, nObjIdx).Yaw_deg = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).Yaw_deg;
            Mobileye.DynObjList(BrainSyncIdx, nObjIdx).Width_m = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).Width_m;
            Mobileye.DynObjList(BrainSyncIdx, nObjIdx).Length_m = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).Length_m;
        end
    end
    fprintf('\b\b\b\b\b\b\b\b %.3d %%', floor(100*BrainSyncIdx/(length(BrainFlexRayFrames.Time)-1)));
end
fprintf('[complete]\n');
end

