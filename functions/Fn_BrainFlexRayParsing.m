function BrainFlexRayFrames_Byte = Fn_BrainFlexRayParsing(db_mat_Path, Logging_csv_path)
%%  File Name: Fn_BrainFlexRayParsing.m
%  Description: Brain FlexRay data parsing
%  Copyright(C) 2014 ACE Lab, All Right Reserved.
% *************************************************************************

%% mat db parsing
load(db_mat_Path);

%% csv brain logging file read
fileID = fopen(Logging_csv_path,'r');
Delimiter = ',';
HeaderArray = textscan(fileID,'%[^\n\r]', 1,'Delimiter', Delimiter,'ReturnOnError', false);
fclose(fileID);

% Message logging structure read
Headline = strsplit(HeaderArray{1}{1}, Delimiter);
cLoggedID = {Headline{2:end-1}};
dLoggedID = zeros(length(cLoggedID),1);
for nIndex = 1:length(cLoggedID)
    dLoggedID(nIndex) = str2double(cLoggedID{nIndex});
    if str2double(cLoggedID{nIndex}) == 0
        dLoggedID = dLoggedID(1:nIndex-1);
       break; 
    end
end

% Data structure define
DataFormat = '%f';
for nIndex = 1:length(dLoggedID)
    Temp_DataFormat = [DataFormat '%f%f%f%f%f%f%f%f%f'];
    DataFormat = Temp_DataFormat;
end
DataFormat = [DataFormat '%[^\n\r]'];

fileID = fopen(Logging_csv_path,'r');
fprintf('\n  - ''*.csv'' file open...');
ImportDataArray = textscan(fileID,DataFormat, 'Delimiter', Delimiter,'ReturnOnError', false,'Headerlines',1);
fprintf('[Complete]\n');
fclose(fileID);

% msec to sec conversion
Time = ImportDataArray{1}/1000; % [sec]

BrainLogged_Frames = cell(1,length(dLoggedID));
fprintf('  - ''*.csv'' file parsing...    ');
for nIndex = 1:length(dLoggedID)
    for nSearchIndex = 1:length(FlexRayFrames)
        if FlexRayFrames{nSearchIndex}.ID == dLoggedID(nIndex)
            TempStruct = FlexRayFrames{nSearchIndex};
            
            % Data structure ID(if null frame, it is 0), Data1, Data2, ..., Data8
            TempID = ImportDataArray{9*nIndex-7};
            TempData = [ImportDataArray{9*nIndex-6},...
                ImportDataArray{9*nIndex-5},...
                ImportDataArray{9*nIndex-4},...
                ImportDataArray{9*nIndex-3},...
                ImportDataArray{9*nIndex-2},...
                ImportDataArray{9*nIndex-1},...
                ImportDataArray{9*nIndex},...
                ImportDataArray{9*nIndex+1}];
        end
    end
    
    for nRefineIndex = 1:length(TempID)
        if TempID(nRefineIndex) == 0 % Null frame -> NaN
            TempData(nRefineIndex,:) = NaN*ones(1,8);
        end
    end
    
    % Data and time information add
    TempStruct.Data = TempData;
    TempStruct.Time = Time;
    
    BrainLogged_Frames{nIndex} = TempStruct;
    
    fprintf('\b\b\b\b%3d%%',uint16(100.*nIndex/length(dLoggedID)));
end

BrainFlexRayFrames_Byte = BrainLogged_Frames;
end