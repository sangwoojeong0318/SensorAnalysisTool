%%  File Name: Main_DataAnalysis.m
%  Description: Synchronizing datas (Brain CAN.csv, FlexRay.csv, CANoe.mat
%  Copyright(C) 2017 ACE Lab, All Right Reserved.
% *************************************************************************
clearvars; close all; clc;
%% Configuration
GridSize_Lon = 5; %[m]
GridSize_Lat = 3; %[m]

Confidence = 5.991; % 95% confidence
%% 0. Select file
try
    % load the previous path *.mat file
    load PrevPath;
    % File path select from ui window with previous file path
    [Filename, Pathname] = uigetfile('*.mat', 'Select MAT File to Analyze', LoadPath,'MultiSelect','on');
catch err
    % File path select from ui window
    [Filename, Pathname] = uigetfile('*.mat', 'Select MAT File to Analyze','MultiSelect','on');
end

if iscell(Filename)
    % Multiple file selected
    nFileCount = length(Filename);
    isMultiFile = true;
    
    LoadPath = [Pathname,Filename{1}];
    save('PrevPath','LoadPath')
else
    % Single file selected
    nFileCount = 1;
    isMultiFile = false;
    
    LoadPath = [Pathname,Filename];
    save('PrevPath','LoadPath')
    Filename = {Filename};
end
%% 1. File read
data = cell(0);

for nFileIdx = 1:length(Filename)
    tmp_LoadPath = [Pathname,Filename{nFileIdx}];
    
    data{nFileIdx} = load(tmp_LoadPath);
end
%% 2. FoV analysis
%%  2.1. Plot configuration
scrsz = get(0,'ScreenSize');
PlotArrSize = [5 4]; % Plot arrange size
Plot_ColorTable % Load the plot color code
Range_smooth = 100;

Delphi_Plot = true;
Stereo_Plot = false;
FusionBox_Plot = false;
Reference_Polt = true;
Stereo_Plot = true;

%%  2.2. Plot
%% Stereo
if Stereo_Plot == true
    % Position
    Row = 2;
    Column = 1;
    tmp_StereoPointSet_PosX = zeros(0);
    tmp_StereoPointSet_PosY = zeros(0);
    tmp_StereoRefSet_PosX = zeros(0);
    tmp_StereoRefSet_PosY = zeros(0);
    
    
    figure('Name','Stereo dectected position','NumberTitle','off','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     scrsz(4)/PlotArrSize(2)*(PlotArrSize(2)-Row) ...
        scrsz(3)/PlotArrSize(1)                scrsz(4)/PlotArrSize(2) ]           );
    
    hold on;
    plot(0,0,'bp');
    for idxStereo = 1:length(data)
        tmpX = data{idxStereo}.aSensorErrList.Reference.PosX(data{idxStereo}.aSensorErrList.Reference.ObjectFlag.Stereo);
        tmpY = data{idxStereo}.aSensorErrList.Reference.PosY(data{idxStereo}.aSensorErrList.Reference.ObjectFlag.Stereo);
        if (~isempty(data{idxStereo}.aSensorErrList.Stereo))
            tmp_Buffer = [tmp_StereoPointSet_PosX, data{idxStereo}.aSensorErrList.Stereo.ref.PosX'];
            tmp_StereoPointSet_PosX = tmp_Buffer;
            tmp_Buffer = [tmp_StereoPointSet_PosY, data{idxStereo}.aSensorErrList.Stereo.ref.PosY'];
            tmp_StereoPointSet_PosY = tmp_Buffer;
            
            tmp_Buffer = [tmp_StereoRefSet_PosX, tmpX'];
            tmp_StereoRefSet_PosX = tmp_Buffer;
            tmp_Buffer = [tmp_StereoRefSet_PosY, tmpY'];
            tmp_StereoRefSet_PosY = tmp_Buffer;
            
            ValidMask = logical(data{idxStereo}.aSensorErrList.Stereo.bTrackValid);
            plot(data{idxStereo}.aSensorErrList.Stereo.ref.PosY(ValidMask), data{idxStereo}.aSensorErrList.Stereo.ref.PosX(ValidMask),'o','color',PlotColorCode(4,:),'MarkerSize',4); hold on;
            plot(tmpY, tmpX,'^','color',PlotColorCode(8,:),'MarkerSize',4);
        end
    end
    
    StereoBoundary = boundary(tmp_StereoPointSet_PosY', tmp_StereoPointSet_PosX',0.01);
    StereoRefBoundary = boundary(tmp_StereoRefSet_PosY', tmp_StereoRefSet_PosX', 0.01);

    plot(tmp_StereoPointSet_PosY(StereoBoundary), tmp_StereoPointSet_PosX(StereoBoundary),'color',PlotColorCode(8,:),'LineWidth',2);
    plot(tmp_StereoRefSet_PosY(StereoRefBoundary), tmp_StereoRefSet_PosX(StereoRefBoundary),'color',PlotColorCode(8,:),'LineWidth',2);
    legend('Ego vehicle', 'Stereo', 'GPS');
    grid on; axis equal; box on; hold off;
    
    xlabel('PosY [m]');
    ylabel('PosX [m]');
    
    % Velocity
    Column = 2;
    figure('Name','Stereo dectected velocity','NumberTitle','off','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     scrsz(4)/PlotArrSize(2)*(PlotArrSize(2)-Row) ...
        scrsz(3)/PlotArrSize(1)                scrsz(4)/PlotArrSize(2) ]           );
    
    subplot(211)
    hold on;
    for idxStereo= 1:length(data)
        if (~isempty(data{idxStereo}.aSensorErrList.Stereo))
            % V from stereo
            plot(data{idxStereo}.aSensorErrList.Stereo.Time(:), data{idxStereo}.aSensorErrList.Stereo.ref.V(:),'.-','color',PlotColorCode(2,:),'MarkerSize',4, 'Linewidth', 2); hold on;
            
            % V from GPS
            plot(data{idxStereo}.aSensorErrList.Stereo.Time(:), data{idxStereo}.aSensorErrList.Reference.Vel(:),'.-','color',PlotColorCode(8,:),'MarkerSize',4, 'Linewidth', 2);
            
            % V error
%             plot(data{idxStereo}.aSensorErrList.Stereo.Time(:), data{idxStereo}.aSensorErrList.Stereo.V(:),'.-','color',PlotColorCode(2,:),'MarkerSize',4);
        end
    end
    legend('Stereo', 'GPS');
    grid on; axis equal; box on; hold off;
    ylabel('Velocity [m/s]');
    
    % Heading
    subplot(212)
    hold on;
    for idxStereo = 1:length(data)
        if (~isempty(data{idxStereo}.aSensorErrList.Stereo))
            plot(data{idxStereo}.aSensorErrList.Stereo.Time(:), data{idxStereo}.aSensorErrList.Stereo.ref.Heading(:),'color',PlotColorCode(2,:),'MarkerSize',6, 'Linewidth', 2);
            plot(data{idxStereo}.aSensorErrList.Stereo.Time(:), data{idxStereo}.aSensorErrList.Reference.Heading(:),'color',PlotColorCode(8,:),'MarkerSize',6, 'Linewidth', 2);
        end
    end
    legend('Stereo', 'GPS');
    grid on; axis equal; box on; hold off;
    xlabel('Time [sec]');
    ylabel('Heading [deg]');
end

%% reference data
if Reference_Polt == true
    % Position
    Row = 4;
    Column = 1;
    figure('Name','Reference dectected position','NumberTitle','off','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     scrsz(4)/PlotArrSize(2)*(PlotArrSize(2)-Row) ...
        scrsz(3)/PlotArrSize(1)                scrsz(4)/PlotArrSize(2) ]           );
    hold on;
    for idxReference = 1:length(data)
        plot(data{idxReference}.aSensorErrList.Reference.PosY(:,:), data{idxReference}.aSensorErrList.Reference.PosX(:),'.','color',PlotColorCode(10,:),'MarkerSize',4);
        
    end
%     fill(tmp_DelphiPointSet_PosY(DelphiBoundary), tmp_DelphiPointSet_PosX(DelphiBoundary),PlotColorCode(2,:),'facealpha',0.3);
    fill(tmp_StereoPointSet_PosY(StereoBoundary), tmp_StereoPointSet_PosX(StereoBoundary),PlotColorCode(4,:),'facealpha',0.3);
%     fill(tmp_FusionBoxPointSet_PosY(FusionBoxBoundary), tmp_FusionBoxPointSet_PosX(FusionBoxBoundary),PlotColorCode(6,:),'facealpha',0.3);
    grid on; axis equal; box on; hold off;
    
    xlabel('PosY [m]');
    ylabel('PosX [m]');
    
    % Velocity
    Column = 2;
    figure('Name','Reference dectected velocity','NumberTitle','off','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     scrsz(4)/PlotArrSize(2)*(PlotArrSize(2)-Row) ...
        scrsz(3)/PlotArrSize(1)                scrsz(4)/PlotArrSize(2) ]           );
    
    subplot(211)
    hold on;
    for idxReference = 1:length(data)
        ReferenceVelocity = sqrt(((data{idxReference}.aSensorErrList.Reference.VelX(:,:)).^2)+((data{idxReference}.aSensorErrList.Reference.VelY(:,:)).^2));
        plot(data{idxReference}.aSensorErrList.Reference.Time(:), ReferenceVelocity(:),'.','color',PlotColorCode(10,:),'MarkerSize',4);
    end
    grid on; axis equal; box on; hold off;
    ylabel('Velocity [m/s]');
    
    subplot(212)
    % Heading
    hold on;
    for idxReference = 1:length(data)
        plot(data{idxReference}.aSensorErrList.Reference.Time(:), data{idxReference}.aSensorErrList.Reference.Heading(:,:),'color',PlotColorCode(10,:),'MarkerSize',4);
    end
    grid on; axis equal; box on; hold off;
    xlabel('Time [sec]');
    ylabel('Heading [deg]');
    
end
%% 3. Error estimation
%%   3.1. Grid generation
% Stereo
tmp_Idx = -GridSize_Lon:-GridSize_Lon:(min(tmp_StereoPointSet_PosX)-0.5*GridSize_Lon);
Stereo_GridX_Idx2meter = [tmp_Idx(length(tmp_Idx):-1:1), 0:GridSize_Lon:(max(tmp_StereoPointSet_PosX)+0.5*GridSize_Lon)];

tmp_Idx = -GridSize_Lat:-GridSize_Lat:(min(tmp_StereoPointSet_PosY)-0.5*GridSize_Lat);
Stereo_GridY_Idx2meter = [tmp_Idx(length(tmp_Idx):-1:1), 0:GridSize_Lat:(max(tmp_StereoPointSet_PosY)+0.5*GridSize_Lat)];

Stereo_GridX_meter2Idx = @(meter) ceil((meter - min(Stereo_GridX_Idx2meter) + 0.5*GridSize_Lon) / GridSize_Lon);
Stereo_GridY_meter2Idx = @(meter) ceil((meter - min(Stereo_GridY_Idx2meter) + 0.5*GridSize_Lat) / GridSize_Lat);

Stereo_Grid = cell(length(Stereo_GridX_Idx2meter), length(Stereo_GridY_Idx2meter));
Stereo_Grid_Object = cell(length(Stereo_GridX_Idx2meter), length(Stereo_GridY_Idx2meter));

%% Object aquisition
for nFileIdx = 1:length(data)
    tmp_sensorList = data{nFileIdx}.aSensorErrList;

    %% Stereo
    if Stereo_Plot == false
        continue;
    end
    if ~isempty(tmp_sensorList.Stereo)
        ValidMask = tmp_sensorList.Stereo.bTrackValid;
        
        for nIndex = 1:length(tmp_sensorList.Stereo.bTrackValid)
            if ValidMask(nIndex) == false; continue; end
            
            tmp_X_Idx = Stereo_GridX_meter2Idx(tmp_sensorList.Stereo.ref.PosX(nIndex));
            tmp_Y_Idx = Stereo_GridY_meter2Idx(tmp_sensorList.Stereo.ref.PosY(nIndex));
            
            tmp_Object.bTrackValid = tmp_sensorList.Stereo.bTrackValid(nIndex);
            tmp_Object.Time = tmp_sensorList.Stereo.Time(nIndex);
            tmp_Object.NumofObj = tmp_sensorList.Stereo.NumofObj(nIndex);
            tmp_Object.nID = tmp_sensorList.Stereo.nID(nIndex);
            tmp_Object.Valid = tmp_sensorList.Stereo.Valid(nIndex);
            tmp_Object.PosX = tmp_sensorList.Stereo.PosX(nIndex);
            tmp_Object.PosY = tmp_sensorList.Stereo.PosY(nIndex);
            tmp_Object.Vx = tmp_sensorList.Stereo.Vx(nIndex);
            tmp_Object.Heading = tmp_sensorList.Stereo.Heading(nIndex);
            tmp_Object.Width = tmp_sensorList.Stereo.Width(nIndex);
            tmp_Object.Length = tmp_sensorList.Stereo.Length(nIndex);
            
            tmp_Object.ref.Time = tmp_sensorList.Stereo.ref.Time(nIndex);
            tmp_Object.ref.nID = tmp_sensorList.Stereo.ref.nID(nIndex);
            tmp_Object.ref.Valid = tmp_sensorList.Stereo.ref.Valid(nIndex);
            tmp_Object.ref.PosX = tmp_sensorList.Stereo.ref.PosX(nIndex);
            tmp_Object.ref.PosY = tmp_sensorList.Stereo.ref.PosY(nIndex);
            tmp_Object.ref.Vx = tmp_sensorList.Stereo.ref.Vx(nIndex);
            tmp_Object.ref.Heading = tmp_sensorList.Stereo.ref.Heading(nIndex);
            tmp_Object.ref.Width = tmp_sensorList.Stereo.ref.Width(nIndex);
            tmp_Object.ref.Length = tmp_sensorList.Stereo.ref.Length(nIndex);
            
            AddIdx = length(Stereo_Grid_Object{tmp_X_Idx, tmp_Y_Idx}) + 1;
            Stereo_Grid_Object{tmp_X_Idx, tmp_Y_Idx}{AddIdx} = tmp_Object;
        end
    end
end
%% Error estimation
%% Stereo
Stereo_error_X = zeros(0);
Stereo_error_Y = zeros(0);

fprintf('  - Analyzing Stereo grid...     ');
for nIdx_X = 1:length(Stereo_GridX_Idx2meter)
    for nIdx_Y = 1:length(Stereo_GridY_Idx2meter)
        fprintf('\b\b\b\b\b%3.f %%',100*nIdx_X*nIdx_Y/(length(Stereo_GridX_Idx2meter)*length(Stereo_GridY_Idx2meter)));
        if isempty(Stereo_Grid_Object{nIdx_X, nIdx_Y}); continue; end
        
        tmp_Stereo_error_X = zeros(0);
        tmp_Stereo_error_Y = zeros(0);
        tmp_Stereo_error_Vx = zeros(0);
        tmp_Stereo_error_Vy = zeros(0);
        tmp_Stereo_error_Heading = zeros(0);
        
        nNumOfObjects = length(Stereo_Grid_Object{nIdx_X,nIdx_Y});
        
        for nObjIdx = 1:nNumOfObjects
            Stereo_error_X(length(Stereo_error_X)+1) = Stereo_GridX_Idx2meter(nIdx_X) + Stereo_Grid_Object{nIdx_X,nIdx_Y}{nObjIdx}.PosX;
            Stereo_error_Y(length(Stereo_error_Y)+1) = Stereo_GridY_Idx2meter(nIdx_Y) + Stereo_Grid_Object{nIdx_X,nIdx_Y}{nObjIdx}.PosY;
            
            
            tmp_Stereo_error_X(length(tmp_Stereo_error_X)+1) = Stereo_Grid_Object{nIdx_X,nIdx_Y}{nObjIdx}.PosX;
            tmp_Stereo_error_Y(length(tmp_Stereo_error_Y)+1) = Stereo_Grid_Object{nIdx_X,nIdx_Y}{nObjIdx}.PosY;
            tmp_Stereo_error_Vx(length(tmp_Stereo_error_Vx)+1) = Stereo_Grid_Object{nIdx_X,nIdx_Y}{nObjIdx}.Vx;
            tmp_Stereo_error_Heading(length(tmp_Stereo_error_Heading)+1) = Stereo_Grid_Object{nIdx_X,nIdx_Y}{nObjIdx}.Heading;
        end
        
        % mean
        tmp_Stereo_Error.PosX_mean = mean(tmp_Stereo_error_X);
        tmp_Stereo_Error.PosY_mean = mean(tmp_Stereo_error_Y);
        
        tmp_Stereo_Error.Vx_mean = mean(tmp_Stereo_error_Vx);
        
        tmp_Stereo_Error.Heading_mean = mean(tmp_Stereo_error_Heading);
        
        % variance
        tmp_Stereo_Error.PosX_var = var(tmp_Stereo_error_X);
        tmp_Stereo_Error.PosY_var = var(tmp_Stereo_error_Y);
        
        tmp_Stereo_Error.Vx_var = var(tmp_Stereo_error_Vx);
        
        tmp_Stereo_Error.Heading_var = var(tmp_Stereo_error_Heading);
        
        
        Stereo_Grid{nIdx_X,nIdx_Y} = tmp_Stereo_Error;
    end
end
fprintf('[complete]\n');

%% Plot grids
% Stereo
Column = 4;
Figure_Stereo_grid = figure('Name','Stereo gridcell','NumberTitle','off','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     0 ...
    scrsz(3)/PlotArrSize(1)                scrsz(4) ]           );
set(Figure_Stereo_grid,'WindowButtonUpFcn',{@Callback_Stereogrid});

[tmp_X, tmp_Y] = meshgrid(Stereo_GridX_Idx2meter, Stereo_GridY_Idx2meter);

hold on; axis equal; box on; grid on;
fill(tmp_StereoPointSet_PosY(StereoBoundary), tmp_StereoPointSet_PosX(StereoBoundary),PlotColorCode(2,:),'facealpha',0.1);
plot(tmp_Y, tmp_X, '.','color',PlotColorCode(2,:));
plot(Stereo_error_Y, Stereo_error_X,'b.');
hold off;
title('Stereo Grid Cell', 'FontSize', 16);
xlabel('PosY [m]');
ylabel('PosX [m]');