function Delphi = Fn_BrainDelphiSync( BrainFlexRayFrames, Delphi_DataFrames )
%%  File Name: Fn_BrainDelphiSync.m
%  Description: Brain Delphi Synchronizaion
%  Author: Wooyoung Lee
%  Copyright(C) 2017 ACE Lab, All Right Reserved.
% *************************************************************************

%% Data type define
delphiSyncIdx = 1;
%% Synchronizaion
fprintf('  - Sync the Delphi exported data ...      ');

for BrainSyncIdx = 1 : (length(BrainFlexRayFrames.Time)-1)
    if (BrainFlexRayFrames.Time(BrainSyncIdx) <= Delphi_DataFrames.Time(delphiSyncIdx))...
            &&(BrainFlexRayFrames.Time(BrainSyncIdx+1) >= Delphi_DataFrames.Time(delphiSyncIdx))
        
        Delphi.Time(BrainSyncIdx, 1) = Delphi_DataFrames.Time(delphiSyncIdx);
        Delphi.DataSize(BrainSyncIdx, 1) = Delphi_DataFrames.DataSize(delphiSyncIdx);
        
        for nObjIdx = 1:1:Delphi_DataFrames.MaxNumofObject(delphiSyncIdx, 1)
            Delphi.DynObjList(BrainSyncIdx, nObjIdx).nID = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).nID;
            Delphi.DynObjList(BrainSyncIdx, nObjIdx).nAge = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).nAge;
            Delphi.DynObjList(BrainSyncIdx, nObjIdx).X_m = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).X_m;
            Delphi.DynObjList(BrainSyncIdx, nObjIdx).Y_m = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).Y_m;
            Delphi.DynObjList(BrainSyncIdx, nObjIdx).Vx_mps = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).Vx_mps;
            Delphi.DynObjList(BrainSyncIdx, nObjIdx).Vy_mps = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).Vy_mps;
            Delphi.DynObjList(BrainSyncIdx, nObjIdx).AccX = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).AccX;
            Delphi.DynObjList(BrainSyncIdx, nObjIdx).Yaw_deg = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).Yaw_deg;
            Delphi.DynObjList(BrainSyncIdx, nObjIdx).Width_m = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).Width_m;
        end
        delphiSyncIdx = delphiSyncIdx + 1;
    else
        Delphi.Time(BrainSyncIdx, 1) = Delphi_DataFrames.Time(delphiSyncIdx);
        Delphi.DataSize(BrainSyncIdx, 1) = Delphi_DataFrames.DataSize(delphiSyncIdx);  
  
        for nObjIdx = 1:1:Delphi_DataFrames.MaxNumofObject(delphiSyncIdx, 1)
            Delphi.DynObjList(BrainSyncIdx, nObjIdx).nID = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).nID;
            Delphi.DynObjList(BrainSyncIdx, nObjIdx).nAge = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).nAge;
            Delphi.DynObjList(BrainSyncIdx, nObjIdx).X_m = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).X_m;
            Delphi.DynObjList(BrainSyncIdx, nObjIdx).Y_m = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).Y_m;
            Delphi.DynObjList(BrainSyncIdx, nObjIdx).Vx_mps = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).Vx_mps;
            Delphi.DynObjList(BrainSyncIdx, nObjIdx).Vy_mps = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).Vy_mps;
            Delphi.DynObjList(BrainSyncIdx, nObjIdx).AccX = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).AccX;
            Delphi.DynObjList(BrainSyncIdx, nObjIdx).Yaw_deg = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).Yaw_deg;
            Delphi.DynObjList(BrainSyncIdx, nObjIdx).Width_m = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).Width_m;
        end
    end
    
    fprintf('\b\b\b\b\b\b %.3d %%', floor(100*BrainSyncIdx/(length(BrainFlexRayFrames.Time)-1)));

end
fprintf('[complete]\n');


end

