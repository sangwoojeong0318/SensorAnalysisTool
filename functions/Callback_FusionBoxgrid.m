function Callback_FusionBoxgrid(handle, event, handles)

% select grid
pt = get(gca,'currentpoint');

tmp_x = pt(1,1);
tmp_y = pt(1,2);

try 
    Figure_FusionBoxCell = evalin('base','Figure_FusionBoxCell'); 
    Figure_FusionBoxRow = evalin('base','Figure_FusionBoxRow'); 
    Figure_FusionBoxColumn = evalin('base','Figure_FusionBoxColumn'); 
catch 
    scrsz = evalin('base','scrsz'); 
    PlotArrSize = evalin('base','PlotArrSize');
    Figure_FusionBoxCell = figure('Name','FusionBox cell information','NumberTitle','off','Position',[ 0,  0, 2*scrsz(3)/PlotArrSize(1), scrsz(4) ]);
    
    Column = 3;
    Figure_FusionBoxRow = figure('Name','FusionBox error (Row)','NumberTitle','off','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     0 ...
        scrsz(3)/PlotArrSize(1)                scrsz(4) ]           );
    
    Column = 4;
    Figure_FusionBoxColumn = figure('Name','FusionBox error (Col)','NumberTitle','off','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     0 ...
        scrsz(3)/PlotArrSize(1)                scrsz(4) ]           );
    
    assignin('base','Figure_FusionBoxCell',Figure_FusionBoxCell);
    assignin('base','Figure_FusionBoxRow',Figure_FusionBoxRow);
    assignin('base','Figure_FusionBoxColumn',Figure_FusionBoxColumn);
end

% Data aquisition
FusionBox_Grid = evalin('base','FusionBox_Grid'); 
FusionBox_Grid_Object = evalin('base','FusionBox_Grid_Object'); 

FusionBox_GridX_Idx2meter = evalin('base','FusionBox_GridX_Idx2meter'); 
FusionBox_GridY_Idx2meter = evalin('base','FusionBox_GridY_Idx2meter'); 

GridSize_Lat = evalin('base','GridSize_Lat'); 
GridSize_Lon = evalin('base','GridSize_Lon'); 

Confidence = evalin('base','Confidence');

[Val_LON,Idx_X] = min(abs(FusionBox_GridX_Idx2meter - tmp_y));
[Val_LAT,Idx_Y] = min(abs(FusionBox_GridY_Idx2meter - tmp_x));

if (Val_LON > GridSize_Lon) || (Val_LAT > GridSize_Lat); return; end
%% Column and row data
nNumOfState = 5;
List_VarName = {'X', 'Y', 'Vx', 'Vy', 'Hdg'};

% Row
figure(Figure_FusionBoxRow); clf;

tmp_mean_row = NaN(nNumOfState, length(FusionBox_GridY_Idx2meter));
tmp_var_row = NaN(nNumOfState, length(FusionBox_GridY_Idx2meter));
for nIndex = 1:length(FusionBox_GridY_Idx2meter)
    if ~isempty(FusionBox_Grid{Idx_X, nIndex})
        tmp_mean_row(1,nIndex) = FusionBox_Grid{Idx_X, nIndex}.PosX_mean;
        tmp_mean_row(2,nIndex) = FusionBox_Grid{Idx_X, nIndex}.PosY_mean;
        tmp_mean_row(3,nIndex) = FusionBox_Grid{Idx_X, nIndex}.Vx_mean;
        tmp_mean_row(4,nIndex) = FusionBox_Grid{Idx_X, nIndex}.Vy_mean;
        tmp_mean_row(5,nIndex) = FusionBox_Grid{Idx_X, nIndex}.Heading_mean;
        
        tmp_var_row(1,nIndex) = FusionBox_Grid{Idx_X, nIndex}.PosX_var;
        tmp_var_row(2,nIndex) = FusionBox_Grid{Idx_X, nIndex}.PosY_var;
        tmp_var_row(3,nIndex) = FusionBox_Grid{Idx_X, nIndex}.Vx_var;
        tmp_var_row(4,nIndex) = FusionBox_Grid{Idx_X, nIndex}.Vy_var;
        tmp_var_row(5,nIndex) = FusionBox_Grid{Idx_X, nIndex}.Heading_var;
    end
end

for nIndex = 1:nNumOfState
    subplot(nNumOfState*2,1,1+2*(nIndex-1));
    hold on;
    plot(FusionBox_GridY_Idx2meter, tmp_mean_row(nIndex,:),'.-');
    hold off; grid on; box on;
    ylabel([List_VarName{nIndex},' mean']);
    xlim([min(FusionBox_GridY_Idx2meter), max(FusionBox_GridY_Idx2meter)]);
    
    subplot(nNumOfState*2,1,2*nIndex);
    hold on;
    plot(FusionBox_GridY_Idx2meter, tmp_var_row(nIndex,:),'.-');
    hold off; grid on; box on;
    ylabel([List_VarName{nIndex},' var']);
    xlim([min(FusionBox_GridY_Idx2meter), max(FusionBox_GridY_Idx2meter)]);
end
xlabel('Y [m]');



% Column
figure(Figure_FusionBoxColumn); clf;
tmp_mean_col = NaN(nNumOfState, length(FusionBox_GridX_Idx2meter));
tmp_var_col = NaN(nNumOfState, length(FusionBox_GridX_Idx2meter));
for nIndex = 1:length(FusionBox_GridX_Idx2meter)
    if ~isempty(FusionBox_Grid{nIndex, Idx_Y})
        tmp_mean_col(1,nIndex) = FusionBox_Grid{nIndex, Idx_Y}.PosX_mean;
        tmp_mean_col(2,nIndex) = FusionBox_Grid{nIndex, Idx_Y}.PosY_mean;
        tmp_mean_col(3,nIndex) = FusionBox_Grid{nIndex, Idx_Y}.Vx_mean;
        tmp_mean_col(4,nIndex) = FusionBox_Grid{nIndex, Idx_Y}.Vy_mean;
        tmp_mean_col(5,nIndex) = FusionBox_Grid{nIndex, Idx_Y}.Heading_mean;
        
        tmp_var_col(1,nIndex) = FusionBox_Grid{nIndex, Idx_Y}.PosX_var;
        tmp_var_col(2,nIndex) = FusionBox_Grid{nIndex, Idx_Y}.PosY_var;
        tmp_var_col(3,nIndex) = FusionBox_Grid{nIndex, Idx_Y}.Vx_var;
        tmp_var_col(4,nIndex) = FusionBox_Grid{nIndex, Idx_Y}.Vy_var;
        tmp_var_col(5,nIndex) = FusionBox_Grid{nIndex, Idx_Y}.Heading_var;
    end
end

for nIndex = 1:nNumOfState
    subplot(nNumOfState*2,1,1+2*(nIndex-1));
    hold on;
    plot(FusionBox_GridX_Idx2meter, tmp_mean_col(nIndex,:),'.-');
    hold off; grid on; box on;
    ylabel([List_VarName{nIndex},' mean']);
    xlim([min(FusionBox_GridX_Idx2meter), max(FusionBox_GridX_Idx2meter)]);
    
    subplot(nNumOfState*2,1,2*nIndex);
    hold on;
    plot(FusionBox_GridX_Idx2meter, tmp_var_col(nIndex,:),'.-');
    hold off; grid on; box on;
    ylabel([List_VarName{nIndex},' var']);
    xlim([min(FusionBox_GridX_Idx2meter), max(FusionBox_GridX_Idx2meter)]);
end
xlabel('X [m]');




%% Cell data
if isempty(FusionBox_Grid{Idx_X, Idx_Y})
    warndlg('No data','Warning')
    figure(Figure_FusionBoxCell);
    clf;
    return; 
end

theta = linspace(0,2*pi,20);

% plot
figure(Figure_FusionBoxCell); clf;
subplot(5,1,[1 2]);
hold on;
% position
plot(0,0,'mp');
tmp_X = zeros(length(FusionBox_Grid_Object{Idx_X, Idx_Y}), 1);
tmp_Y = zeros(length(FusionBox_Grid_Object{Idx_X, Idx_Y}), 1);
for nObjIdx = 1:length(FusionBox_Grid_Object{Idx_X, Idx_Y})
    tmp_X(nObjIdx) = FusionBox_Grid_Object{Idx_X, Idx_Y}{nObjIdx}.PosX;
    tmp_Y(nObjIdx) = FusionBox_Grid_Object{Idx_X, Idx_Y}{nObjIdx}.PosY;
end
plot(tmp_Y, tmp_X, 'b.');
plot(FusionBox_Grid{Idx_X, Idx_Y}.PosY_mean + sqrt(FusionBox_Grid{Idx_X, Idx_Y}.PosY_var*Confidence)*cos(theta), ...
    FusionBox_Grid{Idx_X, Idx_Y}.PosX_mean + sqrt(FusionBox_Grid{Idx_X, Idx_Y}.PosX_var*Confidence)*sin(theta), 'r');
plot(FusionBox_Grid{Idx_X, Idx_Y}.PosY_mean, FusionBox_Grid{Idx_X, Idx_Y}.PosX_mean,'ro');
xlabel('Y [m]'), ylabel('X [m]'); grid on; box on; axis equal;
hold off;

title(['Information in cell (',mat2str(FusionBox_GridX_Idx2meter(Idx_X)),', ',mat2str(FusionBox_GridY_Idx2meter(Idx_Y)),')']);

subplot(5,1,3);
% velocity X
hold on;
plot(0,0,'mp');
tmp_Vx = zeros(length(FusionBox_Grid_Object{Idx_X, Idx_Y}), 1);
for nObjIdx = 1:length(FusionBox_Grid_Object{Idx_X, Idx_Y})
    tmp_Vx(nObjIdx) = FusionBox_Grid_Object{Idx_X, Idx_Y}{nObjIdx}.Vx;
end
plot(tmp_Vx,zeros(length(tmp_Vx),1), 'b.');
plot(FusionBox_Grid{Idx_X, Idx_Y}.Vx_mean + sqrt(FusionBox_Grid{Idx_X, Idx_Y}.Vx_var*Confidence)*[-1, 1],[0 0],'r*-');
histogram(tmp_Vx);
plot(FusionBox_Grid{Idx_X, Idx_Y}.Vx_mean, 0,'ro'); 
xlabel('Vel_x [m/s]');
hold off; box on;

% velocity Y
subplot(5,1,4);
hold on;
plot(0,0,'mp');
tmp_Vy = zeros(length(FusionBox_Grid_Object{Idx_X, Idx_Y}), 1);
for nObjIdx = 1:length(FusionBox_Grid_Object{Idx_X, Idx_Y})
    tmp_Vy(nObjIdx) = FusionBox_Grid_Object{Idx_X, Idx_Y}{nObjIdx}.Vy;
end
plot(tmp_Vy,zeros(length(tmp_Vy),1), 'b.');
plot(FusionBox_Grid{Idx_X, Idx_Y}.Vy_mean + sqrt(FusionBox_Grid{Idx_X, Idx_Y}.Vy_var*Confidence)*[-1, 1],[0 0],'r*-');
histogram(tmp_Vy);
plot(FusionBox_Grid{Idx_X, Idx_Y}.Vy_mean, 0,'ro'); 
xlabel('Vel_y [m/s]');
hold off; box on;

subplot(5,1,5);
% heading
hold on;
plot(0,0,'mp');
tmp_Heading = zeros(length(FusionBox_Grid_Object{Idx_X, Idx_Y}), 1);
for nObjIdx = 1:length(FusionBox_Grid_Object{Idx_X, Idx_Y})
    tmp_Heading(nObjIdx) =FusionBox_Grid_Object{Idx_X, Idx_Y}{nObjIdx}.Heading;
    
end
plot(tmp_Heading,zeros(length(tmp_Heading),1), 'b.');
plot(FusionBox_Grid{Idx_X, Idx_Y}.Heading_mean + sqrt(FusionBox_Grid{Idx_X, Idx_Y}.Heading_var*Confidence)*[-1, 1],[0 0],'r*-');
histogram(tmp_Heading);
plot(FusionBox_Grid{Idx_X, Idx_Y}.Heading_mean, 0,'ro'); 
xlabel('Heading [deg]');
hold off; box on;



end