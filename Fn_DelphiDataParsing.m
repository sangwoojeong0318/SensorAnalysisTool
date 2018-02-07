function DelphiFrames = Fn_DelphiDataParsing(Logging_csv_path)
%%  File Name: Fn_DelphiDataParsing.m
%  Description: Brain CAN data parsing
%  Author: Wooyoung Lee
%  Copyright(C) 2017 ACE Lab, All Right Reserved.
% *************************************************************************

%% Data type define
nNumofDataField = 9;


%% csv brain logging file read
fID = fopen(Logging_csv_path);
ScanLines = textscan(fID, '%[^\n\r]');
fclose(fID);
ScanLines = ScanLines{1};

nTimeIdx = 0;
fprintf('  - Parsing the Delphi radar exported data ...      ');

for nScanLineIdx = 2:length(ScanLines)
    tmp_Elements = strsplit(ScanLines{nScanLineIdx},',');
    tmp_time = str2double(tmp_Elements{1});
    tmp_DataSize = str2double(tmp_Elements{2});
    tmp_MaxNumofObj = str2double(tmp_Elements{3});
    nNumOfData  = length(tmp_Elements) - sum(strcmp(tmp_Elements,'')) - 1; %1: time
    
    nTimeIdx =  nTimeIdx + 1;

    tmp_DelphiFrames.Time(nTimeIdx, 1) = tmp_time * 0.001; % logging time
    tmp_DelphiFrames.DataSize(nTimeIdx, 1) = tmp_DataSize;
    tmp_DelphiFrames.MaxNumofObject(nTimeIdx, 1) = tmp_MaxNumofObj;

    for nObjectIdx = 1:nNumOfData/nNumofDataField

        tmp_DelphiFrames.DynObjList.nID(nTimeIdx, nObjectIdx) = str2double(tmp_Elements{4+(nObjectIdx-1)*nNumofDataField});
        tmp_DelphiFrames.DynObjList.nAge(nTimeIdx, nObjectIdx) = str2double(tmp_Elements{5+(nObjectIdx-1)*nNumofDataField});
        tmp_DelphiFrames.DynObjList.X_m(nTimeIdx, nObjectIdx) = str2double(tmp_Elements{6+(nObjectIdx-1)*nNumofDataField});
        tmp_DelphiFrames.DynObjList.Y_m(nTimeIdx, nObjectIdx) = str2double(tmp_Elements{7+(nObjectIdx-1)*nNumofDataField});
        tmp_DelphiFrames.DynObjList.Vx_mps(nTimeIdx, nObjectIdx) = str2double(tmp_Elements{8+(nObjectIdx-1)*nNumofDataField});
        tmp_DelphiFrames.DynObjList.Vy_mps(nTimeIdx, nObjectIdx) = str2double(tmp_Elements{9+(nObjectIdx-1)*nNumofDataField});
        tmp_DelphiFrames.DynObjList.AccX(nTimeIdx, nObjectIdx) = str2double(tmp_Elements{10+(nObjectIdx-1)*nNumofDataField});
        tmp_DelphiFrames.DynObjList.Yaw_deg(nTimeIdx, nObjectIdx) = str2double(tmp_Elements{11+(nObjectIdx-1)*nNumofDataField});
        tmp_DelphiFrames.DynObjList.Width_m(nTimeIdx, nObjectIdx) = str2double(tmp_Elements{12+(nObjectIdx-1)*nNumofDataField});

        fprintf('\b\b\b\b\b\b %.3d %%', floor(100*nScanLineIdx/length(ScanLines)));
    end
    
end

DelphiFrames = tmp_DelphiFrames;

fprintf('[complete]\n');
end

