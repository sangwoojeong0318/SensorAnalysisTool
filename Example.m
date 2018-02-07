clearvars SyncData;
delphiSyncIdx = 1;
meyeSyncIdx = 1;

fprintf('  - Parsing the FusionBox exported data ...      ');

for BrainSyncIdx = 1 : (length(BrainFlexRayFrames.Time)-1)
    if (BrainFlexRayFrames.Time(BrainSyncIdx) <= Delphi_DataFrames.Time(delphiSyncIdx))...
            &&(BrainFlexRayFrames.Time(BrainSyncIdx+1) >= Delphi_DataFrames.Time(delphiSyncIdx))
        
        SyncData.Delphi.Time(BrainSyncIdx, 1) = Delphi_DataFrames.Time(delphiSyncIdx);
        SyncData.Delphi.DataSize(BrainSyncIdx, 1) = Delphi_DataFrames.DataSize(delphiSyncIdx);
        
        for nObjIdx = 1:1:Delphi_DataFrames.MaxNumofObject(delphiSyncIdx, 1)
            SyncData.Delphi.DynObjList(BrainSyncIdx, nObjIdx).nID = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).nID;
            SyncData.Delphi.DynObjList(BrainSyncIdx, nObjIdx).nAge = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).nAge;
            SyncData.Delphi.DynObjList(BrainSyncIdx, nObjIdx).X_m = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).X_m;
            SyncData.Delphi.DynObjList(BrainSyncIdx, nObjIdx).Y_m = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).Y_m;
            SyncData.Delphi.DynObjList(BrainSyncIdx, nObjIdx).Vx_mps = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).Vx_mps;
            SyncData.Delphi.DynObjList(BrainSyncIdx, nObjIdx).Vy_mps = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).Vy_mps;
            SyncData.Delphi.DynObjList(BrainSyncIdx, nObjIdx).AccX = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).AccX;
            SyncData.Delphi.DynObjList(BrainSyncIdx, nObjIdx).Yaw_deg = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).Yaw_deg;
            SyncData.Delphi.DynObjList(BrainSyncIdx, nObjIdx).Width_m = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).Width_m;
        end
        delphiSyncIdx = delphiSyncIdx + 1;
    else
%         SyncData.Delphi.Time(BrainSyncIdx, 1) = Delphi_DataFrames.Time(delphiSyncIdx);
%         SyncData.Delphi.DataSize(BrainSyncIdx, 1) = Delphi_DataFrames.DataSize(delphiSyncIdx);  
%   
%         for nObjIdx = 1:1:Delphi_DataFrames.MaxNumofObject(delphiSyncIdx, 1)
%             SyncData.Delphi.DynObjList(BrainSyncIdx, nObjIdx).nID = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).nID;
%             SyncData.Delphi.DynObjList(BrainSyncIdx, nObjIdx).nAge = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).nAge;
%             SyncData.Delphi.DynObjList(BrainSyncIdx, nObjIdx).X_m = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).X_m;
%             SyncData.Delphi.DynObjList(BrainSyncIdx, nObjIdx).Y_m = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).Y_m;
%             SyncData.Delphi.DynObjList(BrainSyncIdx, nObjIdx).Vx_mps = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).Vx_mps;
%             SyncData.Delphi.DynObjList(BrainSyncIdx, nObjIdx).Vy_mps = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).Vy_mps;
%             SyncData.Delphi.DynObjList(BrainSyncIdx, nObjIdx).AccX = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).AccX;
%             SyncData.Delphi.DynObjList(BrainSyncIdx, nObjIdx).Yaw_deg = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).Yaw_deg;
%             SyncData.Delphi.DynObjList(BrainSyncIdx, nObjIdx).Width_m = Delphi_DataFrames.DynObjList(delphiSyncIdx, nObjIdx).Width_m;
%         end
    end
    
    if (BrainFlexRayFrames.Time(BrainSyncIdx) <= Mobileye_DataFrames.Time(meyeSyncIdx))...
            &&(BrainFlexRayFrames.Time(BrainSyncIdx+1) >= Mobileye_DataFrames.Time(meyeSyncIdx))
        
        SyncData.Mobileye.Time(BrainSyncIdx, 1) = Mobileye_DataFrames.Time(meyeSyncIdx);
        SyncData.Mobileye.DataSize(BrainSyncIdx, 1) = Mobileye_DataFrames.DataSize(meyeSyncIdx);
        
        for nObjIdx = 1:1:Mobileye_DataFrames.MaxNumofObject(meyeSyncIdx, 1)
            SyncData.Mobileye.DynObjList(BrainSyncIdx, nObjIdx).nID = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).nID;
            SyncData.Mobileye.DynObjList(BrainSyncIdx, nObjIdx).nAge = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).nAge;
            SyncData.Mobileye.DynObjList(BrainSyncIdx, nObjIdx).Type = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).Type;
            SyncData.Mobileye.DynObjList(BrainSyncIdx, nObjIdx).Valid = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).Valid;
            SyncData.Mobileye.DynObjList(BrainSyncIdx, nObjIdx).X_m = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).X_m;
            SyncData.Mobileye.DynObjList(BrainSyncIdx, nObjIdx).Y_m = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).Y_m;
            SyncData.Mobileye.DynObjList(BrainSyncIdx, nObjIdx).Vx_mps = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).Vx_mps;
            SyncData.Mobileye.DynObjList(BrainSyncIdx, nObjIdx).Yaw_deg = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).Yaw_deg;
            SyncData.Mobileye.DynObjList(BrainSyncIdx, nObjIdx).Width_m = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).Width_m;
            SyncData.Mobileye.DynObjList(BrainSyncIdx, nObjIdx).Length_m = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).Length_m;
        end
        
    else
%         SyncData.Mobileye.Time(BrainSyncIdx, 1) = Mobileye_DataFrames.Time(meyeSyncIdx);
%         SyncData.Mobileye.DataSize(BrainSyncIdx, 1) = Mobileye_DataFrames.DataSize(meyeSyncIdx);
%         
%         for nObjIdx = 1:1:Mobileye_DataFrames.MaxNumofObject(meyeSyncIdx, 1)
%             SyncData.Mobileye.DynObjList(BrainSyncIdx, nObjIdx).nID = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).nID;
%             SyncData.Mobileye.DynObjList(BrainSyncIdx, nObjIdx).nAge = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).nAge;
%             SyncData.Mobileye.DynObjList(BrainSyncIdx, nObjIdx).Type = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).Type;
%             SyncData.Mobileye.DynObjList(BrainSyncIdx, nObjIdx).Valid = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).Valid;
%             SyncData.Mobileye.DynObjList(BrainSyncIdx, nObjIdx).X_m = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).X_m;
%             SyncData.Mobileye.DynObjList(BrainSyncIdx, nObjIdx).Y_m = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).Y_m;
%             SyncData.Mobileye.DynObjList(BrainSyncIdx, nObjIdx).Vx_mps = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).Vx_mps;
%             SyncData.Mobileye.DynObjList(BrainSyncIdx, nObjIdx).Yaw_deg = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).Yaw_deg;
%             SyncData.Mobileye.DynObjList(BrainSyncIdx, nObjIdx).Width_m = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).Width_m;
%             SyncData.Mobileye.DynObjList(BrainSyncIdx, nObjIdx).Length_m = Mobileye_DataFrames.DynObjList(meyeSyncIdx, nObjIdx).Length_m;
%         end
    end
        fprintf('\b\b\b\b\b\b %.3d %%',floor(100*BrainSyncIdx/(length(BrainFlexRayFrames.Time)-1)));

%         fprintf('\b\b\b\b\b\b\b\b %.3d %%', floor(100*BrainSyncIdx/(length(BrainFlexRayFrames.Time)-1)));

end