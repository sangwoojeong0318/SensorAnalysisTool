function Data = Fn_FusionBoxParsing(FilePath)

%% Data type define
Data.Time = zeros(1,1);
% point cloud
PtCloud_typeInit.X_m = zeros(0);
PtCloud_typeInit.Y_m = zeros(0);
PtCloud_typeInit.Z_m = zeros(0);

% Dynamic object
DynObj_typeInit.X_m = zeros(0);
DynObj_typeInit.Y_m = zeros(0);
DynObj_typeInit.Yaw_deg = zeros(0);
DynObj_typeInit.Vx_mps = zeros(0);
DynObj_typeInit.Vy_mps = zeros(0);
DynObj_typeInit.Length_m = zeros(0);
DynObj_typeInit.Width_m = zeros(0);

nTimeIdx = 0;
nNumOfFields = 10;
% Point clound information
% Data.PtCloud = cell(0);
% Dynamic object information
% Data.DynObj = cell(0);


%% Data parsing
fID = fopen(FilePath);
ScanLines = textscan(fID, '%[^\n\r]');
fclose(fID);
ScanLines = ScanLines{1};

fprintf('  - Parsing the FusionBox exported data ...      ');
for nScanLineIdx = 2:length(ScanLines)
    tmp_Elements = strsplit(ScanLines{nScanLineIdx},',');
    nTimeIdx =  nTimeIdx + 1;
    
%     Data.Time(nScanLineIdx-1) = str2double(tmp_Elements{1}) / 1000;    
    Data.Time(nTimeIdx) = str2double(tmp_Elements{1}) / 1000;    

    nNumOfData  = length(tmp_Elements) - sum(strcmp(tmp_Elements,'')) - 3; % 2: time and header and data size
    
    switch(tmp_Elements{2})          
        case  'PointCloud'
%                 nNumOfFields = length(fields(PtCloud_typeInit));
                tmp_PointCloud = PtCloud_typeInit;
                
                for nPointIdx = 1:nNumOfData/nNumOfFields
                    tmp_PointCloud.X_m(nPointIdx) = str2double(tmp_Elements{nNumOfFields*(nPointIdx-1) + 3});
                    tmp_PointCloud.Y_m(nPointIdx) = str2double(tmp_Elements{nNumOfFields*(nPointIdx-1) + 4});
                    tmp_PointCloud.Z_m(nPointIdx) = str2double(tmp_Elements{nNumOfFields*(nPointIdx-1) + 5});
                end
                Data.PtCloud{nScanLineIdx-1} = tmp_PointCloud;
            
        case  'Object'
%                 nNumOfFields = length(fields(DynObj_typeInit));
                
%                 tmp_DynObjList = DynObj_typeInit;
                
                for nObjectIdx = 1:nNumOfData/nNumOfFields
                    tmp_DynObjList.nID(nTimeIdx, nObjectIdx) = str2double(tmp_Elements{nNumOfFields*(nObjectIdx-1) + 4});
                    tmp_DynObjList.nAge(nTimeIdx, nObjectIdx) = str2double(tmp_Elements{nNumOfFields*(nObjectIdx-1) + 5});
                    tmp_DynObjList.Class(nTimeIdx, nObjectIdx) = str2double(tmp_Elements{nNumOfFields*(nObjectIdx-1) + 6});
                    tmp_DynObjList.X_m(nTimeIdx, nObjectIdx) = str2double(tmp_Elements{nNumOfFields*(nObjectIdx-1) + 7});
                    tmp_DynObjList.Y_m(nTimeIdx, nObjectIdx) = str2double(tmp_Elements{nNumOfFields*(nObjectIdx-1) + 8});
                    tmp_DynObjList.Vx_mps(nTimeIdx, nObjectIdx) = str2double(tmp_Elements{nNumOfFields*(nObjectIdx-1) + 9});
                    tmp_DynObjList.Vy_mps(nTimeIdx, nObjectIdx)= str2double(tmp_Elements{nNumOfFields*(nObjectIdx-1) + 10});
                    tmp_DynObjList.Yaw_deg(nTimeIdx, nObjectIdx) = str2double(tmp_Elements{nNumOfFields*(nObjectIdx-1) + 11});                    
                    tmp_DynObjList.Width_m(nTimeIdx, nObjectIdx) = str2double(tmp_Elements{nNumOfFields*(nObjectIdx-1) + 12});
                    tmp_DynObjList.Length_m(nTimeIdx, nObjectIdx) = str2double(tmp_Elements{nNumOfFields*(nObjectIdx-1) + 13});
                    
%                     tmp_DynObjList.Width_m(nTimeIdx, nObjectIdx) = str2double(tmp_Elements{nNumOfFields*(nObjectIdx-1) + 9}) / 1000;
                end
%                 Data.DynObj{nScanLineIdx-1} = tmp_DynObjList;
                Data.DynObj  = tmp_DynObjList;

    end
    
    
    fprintf('\b\b\b\b\b\b %.3d %%', floor(100*nScanLineIdx/length(ScanLines)));
end
fprintf('[complete]\n');


end