function MobileyeFrames = Fn_MobileyeDataParsing( Logging_csv_path )
%%  File Name: Fn_MobileyeDataParsing.m
%  Description: Brain CAN data parsing
%  Author: Wooyoung Lee
%  Copyright(C) 2017 ACE Lab, All Right Reserved.
% *************************************************************************

%% Data type define
nNumofDataField = 10;

%% csv brain logging file read

fID = fopen(Logging_csv_path);
ScanLines = textscan(fID, '%[^\n\r]');
fclose(fID);
ScanLines = ScanLines{1};

nTimeIdx = 0;
fprintf('  - Parsing the Mobileye exported data ...      ');
%% Initialize
nMaxNumOfObject = 0;
for nScanLineIdx = 2:length(ScanLines)
    tmp_Elements = strsplit(ScanLines{nScanLineIdx},',');
    tmp_nMaxNumOfObject  = (length(tmp_Elements) - sum(strcmp(tmp_Elements,'')) - 3)/nNumofDataField; %2: time and size and number of object
    
    if nMaxNumOfObject < tmp_nMaxNumOfObject
        nMaxNumOfObject = tmp_nMaxNumOfObject;
    end
end
tmp_MobileyeFrames.DynObjList.nID = NaN(length(ScanLines)-1, nMaxNumOfObject);
tmp_MobileyeFrames.DynObjList.nAge = NaN(length(ScanLines)-1, nMaxNumOfObject);
tmp_MobileyeFrames.DynObjList.Type = NaN(length(ScanLines)-1, nMaxNumOfObject);
tmp_MobileyeFrames.DynObjList.Valid = NaN(length(ScanLines)-1, nMaxNumOfObject);
tmp_MobileyeFrames.DynObjList.X_m = NaN(length(ScanLines)-1, nMaxNumOfObject);
tmp_MobileyeFrames.DynObjList.Y_m = NaN(length(ScanLines)-1, nMaxNumOfObject);
tmp_MobileyeFrames.DynObjList.Vx_mps = NaN(length(ScanLines)-1, nMaxNumOfObject);
tmp_MobileyeFrames.DynObjList.Yaw_deg = NaN(length(ScanLines)-1, nMaxNumOfObject);
tmp_MobileyeFrames.DynObjList.Width_m = NaN(length(ScanLines)-1, nMaxNumOfObject);
tmp_MobileyeFrames.DynObjList.Length_m = NaN(length(ScanLines)-1, nMaxNumOfObject);

%% Parsing
for nScanLineIdx = 2:length(ScanLines)
    tmp_Elements = strsplit(ScanLines{nScanLineIdx},',');
    tmp_time = str2double(tmp_Elements{1});
    tmp_DataSize = str2double(tmp_Elements{2});
    tmp_MaxNumofObj = str2double(tmp_Elements{3});
    nNumOfData  = length(tmp_Elements) - sum(strcmp(tmp_Elements,'')) - 3; %2: time and size and number of object
    
    nTimeIdx =  nTimeIdx + 1;
    
    tmp_MobileyeFrames.Time(nTimeIdx, 1) = tmp_time * 0.001; % logging time
    tmp_MobileyeFrames.DataSize(nTimeIdx, 1) = tmp_DataSize;
    tmp_MobileyeFrames.MaxNumofObject(nTimeIdx, 1) = tmp_MaxNumofObj;
    
    if nNumOfData ~= 0
        for nObjectIdx = 1:nNumOfData/nNumofDataField
            tmp_MobileyeFrames.DynObjList.nID(nTimeIdx, nObjectIdx) = str2double(tmp_Elements{4+(nObjectIdx-1)*nNumofDataField});
            tmp_MobileyeFrames.DynObjList.nAge(nTimeIdx, nObjectIdx) = str2double(tmp_Elements{5+(nObjectIdx-1)*nNumofDataField});
            tmp_MobileyeFrames.DynObjList.Type(nTimeIdx, nObjectIdx) = str2double(tmp_Elements{6+(nObjectIdx-1)*nNumofDataField});
            tmp_MobileyeFrames.DynObjList.Valid(nTimeIdx, nObjectIdx) = str2double(tmp_Elements{7+(nObjectIdx-1)*nNumofDataField});
            tmp_MobileyeFrames.DynObjList.X_m(nTimeIdx, nObjectIdx) = str2double(tmp_Elements{8+(nObjectIdx-1)*nNumofDataField});
            tmp_MobileyeFrames.DynObjList.Y_m(nTimeIdx, nObjectIdx) = str2double(tmp_Elements{9+(nObjectIdx-1)*nNumofDataField});
            tmp_MobileyeFrames.DynObjList.Vx_mps(nTimeIdx, nObjectIdx) = str2double(tmp_Elements{10+(nObjectIdx-1)*nNumofDataField});
            tmp_MobileyeFrames.DynObjList.Yaw_deg(nTimeIdx, nObjectIdx) = str2double(tmp_Elements{11+(nObjectIdx-1)*nNumofDataField});
            tmp_MobileyeFrames.DynObjList.Width_m(nTimeIdx, nObjectIdx) = str2double(tmp_Elements{12+(nObjectIdx-1)*nNumofDataField});
            tmp_MobileyeFrames.DynObjList.Length_m(nTimeIdx, nObjectIdx) = str2double(tmp_Elements{13+(nObjectIdx-1)*nNumofDataField});      

            fprintf('\b\b\b\b\b\b %.3d %%', floor(100*nScanLineIdx/length(ScanLines)));
        end
    else
            tmp_MobileyeFrames.DynObjList.nID(nTimeIdx, 1) = NaN;
            tmp_MobileyeFrames.DynObjList.nAge(nTimeIdx, 1) = NaN;
            tmp_MobileyeFrames.DynObjList.Type(nTimeIdx, 1) = NaN;
            tmp_MobileyeFrames.DynObjList.Valid(nTimeIdx, 1) = NaN;
            tmp_MobileyeFrames.DynObjList.X_m(nTimeIdx, 1) = NaN;
            tmp_MobileyeFrames.DynObjList.Y_m(nTimeIdx, 1) = NaN;
            tmp_MobileyeFrames.DynObjList.Vx_mps(nTimeIdx, 1) = NaN;
            tmp_MobileyeFrames.DynObjList.Yaw_deg(nTimeIdx, 1) = NaN;
            tmp_MobileyeFrames.DynObjList.Width_m(nTimeIdx, 1) = NaN;
            tmp_MobileyeFrames.DynObjList.Length_m(nTimeIdx, 1) = NaN;

            fprintf('\b\b\b\b\b\b %.3d %%', floor(100*nScanLineIdx/length(ScanLines)));
    end
    
end

MobileyeFrames = tmp_MobileyeFrames;

fprintf('[complete]\n');
end


