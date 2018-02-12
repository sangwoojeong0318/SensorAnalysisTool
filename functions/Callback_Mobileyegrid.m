function Callback_Mobileyegrid(handle, event, handles)

% select grid
pt = get(gca,'currentpoint');

tmp_x = pt(1,1);
tmp_y = pt(1,2);

try 
    Figure_MobileyeCell = evalin('base','Figure_MobileyeCell'); 
    Figure_MobileyeRow = evalin('base','Figure_MobileyeRow'); 
    Figure_MobileyeColumn = evalin('base','Figure_MobileyeColumn'); 
catch 
    scrsz = evalin('base','scrsz'); 
    PlotArrSize = evalin('base','PlotArrSize');
    Figure_MobileyeCell = figure('Name','Mobileye cell information','NumberTitle','off','Position',[ 0,  0, 2*scrsz(3)/PlotArrSize(1), scrsz(4) ]);
    
    Column = 3;
    Figure_MobileyeRow = figure('Name','Mobileye error (Row)','NumberTitle','off','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     0 ...
        scrsz(3)/PlotArrSize(1)                scrsz(4) ]           );
    
    Column = 5;
    Figure_MobileyeColumn = figure('Name','Mobileye error (Col)','NumberTitle','off','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     0 ...
        scrsz(3)/PlotArrSize(1)                scrsz(4) ]           );
    
    assignin('base','Figure_MobileyeCell',Figure_MobileyeCell);
    assignin('base','Figure_MobileyeRow',Figure_MobileyeRow);
    assignin('base','Figure_MobileyeColumn',Figure_MobileyeColumn);
end

% Data aquisition
Mobileye_Grid = evalin('base','Mobileye_Grid'); 
Mobileye_Grid_Object = evalin('base','Mobileye_Grid_Object'); 

Mobileye_GridX_Idx2meter = evalin('base','Mobileye_GridX_Idx2meter'); 
Mobileye_GridY_Idx2meter = evalin('base','Mobileye_GridY_Idx2meter'); 

GridSize_Lat = evalin('base','GridSize_Lat'); 
GridSize_Lon = evalin('base','GridSize_Lon'); 

Confidence = evalin('base','Confidence');

[Val_LON,Idx_X] = min(abs(Mobileye_GridX_Idx2meter - tmp_y));
[Val_LAT,Idx_Y] = min(abs(Mobileye_GridY_Idx2meter - tmp_x));

if (Val_LON > GridSize_Lon) || (Val_LAT > GridSize_Lat); return; end
%% Column and row data
nNumOfState = 4;
List_VarName = {'X', 'Y', 'Vx', 'Hdg'};

% Row
figure(Figure_MobileyeRow); clf;

tmp_mean_row = NaN(nNumOfState, length(Mobileye_GridY_Idx2meter));
tmp_var_row = NaN(nNumOfState, length(Mobileye_GridY_Idx2meter));
for nIndex = 1:length(Mobileye_GridY_Idx2meter)
    if ~isempty(Mobileye_Grid{Idx_X, nIndex})
        tmp_mean_row(1,nIndex) = Mobileye_Grid{Idx_X, nIndex}.PosX_mean;
        tmp_mean_row(2,nIndex) = Mobileye_Grid{Idx_X, nIndex}.PosY_mean;
        tmp_mean_row(3,nIndex) = Mobileye_Grid{Idx_X, nIndex}.Vx_mean;
        tmp_mean_row(4,nIndex) = Mobileye_Grid{Idx_X, nIndex}.Heading_mean;
        
        tmp_var_row(1,nIndex) = Mobileye_Grid{Idx_X, nIndex}.PosX_var;
        tmp_var_row(2,nIndex) = Mobileye_Grid{Idx_X, nIndex}.PosY_var;
        tmp_var_row(3,nIndex) = Mobileye_Grid{Idx_X, nIndex}.Vx_var;
        tmp_var_row(4,nIndex) = Mobileye_Grid{Idx_X, nIndex}.Heading_var;
    end
end

for nIndex = 1:nNumOfState
    subplot(nNumOfState*2,1,1+2*(nIndex-1));
    hold on;
    plot(Mobileye_GridY_Idx2meter, tmp_mean_row(nIndex,:),'.-');
    hold off; grid on; box on;
    ylabel([List_VarName{nIndex},' mean']);
    xlim([min(Mobileye_GridY_Idx2meter), max(Mobileye_GridY_Idx2meter)]);
    
    subplot(nNumOfState*2,1,2*nIndex);
    hold on;
    plot(Mobileye_GridY_Idx2meter, tmp_var_row(nIndex,:),'.-');
    hold off; grid on; box on;
    ylabel([List_VarName{nIndex},' var']);
    xlim([min(Mobileye_GridY_Idx2meter), max(Mobileye_GridY_Idx2meter)]);
end
xlabel('Y [m]');



% Column
figure(Figure_MobileyeColumn); clf;
tmp_mean_col = NaN(nNumOfState, length(Mobileye_GridX_Idx2meter));
tmp_var_col = NaN(nNumOfState, length(Mobileye_GridX_Idx2meter));
for nIndex = 1:length(Mobileye_GridX_Idx2meter)
    if ~isempty(Mobileye_Grid{nIndex, Idx_Y})
        tmp_mean_col(1,nIndex) = Mobileye_Grid{nIndex, Idx_Y}.PosX_mean;
        tmp_mean_col(2,nIndex) = Mobileye_Grid{nIndex, Idx_Y}.PosY_mean;
        tmp_mean_col(3,nIndex) = Mobileye_Grid{nIndex, Idx_Y}.Vx_mean;
        tmp_mean_col(4,nIndex) = Mobileye_Grid{nIndex, Idx_Y}.Heading_mean;
        
        tmp_var_col(1,nIndex) = Mobileye_Grid{nIndex, Idx_Y}.PosX_var;
        tmp_var_col(2,nIndex) = Mobileye_Grid{nIndex, Idx_Y}.PosY_var;
        tmp_var_col(3,nIndex) = Mobileye_Grid{nIndex, Idx_Y}.Vx_var;
        tmp_var_col(4,nIndex) = Mobileye_Grid{nIndex, Idx_Y}.Heading_var;
    end
end

for nIndex = 1:nNumOfState
    subplot(nNumOfState*2,1,1+2*(nIndex-1));
    hold on;
    plot(Mobileye_GridX_Idx2meter, tmp_mean_col(nIndex,:),'.-');
    hold off; grid on; box on;
    ylabel([List_VarName{nIndex},' mean']);
    xlim([min(Mobileye_GridX_Idx2meter), max(Mobileye_GridX_Idx2meter)]);
    
    subplot(nNumOfState*2,1,2*nIndex);
    hold on;
    plot(Mobileye_GridX_Idx2meter, tmp_var_col(nIndex,:),'.-');
    hold off; grid on; box on;
    ylabel([List_VarName{nIndex},' var']);
    xlim([min(Mobileye_GridX_Idx2meter), max(Mobileye_GridX_Idx2meter)]);
end
xlabel('X [m]');




%% Cell data
if isempty(Mobileye_Grid{Idx_X, Idx_Y})
    warndlg('No data','Warning')
    figure(Figure_MobileyeCell);
    clf;
    return; 
end

theta = linspace(0,2*pi,20);

% plot
figure(Figure_MobileyeCell); clf;
subplot(4,1,[1 2]);
hold on;
% position
plot(0,0,'mp');
tmp_X = zeros(length(Mobileye_Grid_Object{Idx_X, Idx_Y}), 1);
tmp_Y = zeros(length(Mobileye_Grid_Object{Idx_X, Idx_Y}), 1);
for nObjIdx = 1:length(Mobileye_Grid_Object{Idx_X, Idx_Y})
    tmp_X(nObjIdx) = Mobileye_Grid_Object{Idx_X, Idx_Y}{nObjIdx}.PosX;
    tmp_Y(nObjIdx) = Mobileye_Grid_Object{Idx_X, Idx_Y}{nObjIdx}.PosY;
end
plot(tmp_Y, tmp_X, 'b.');
plot(Mobileye_Grid{Idx_X, Idx_Y}.PosY_mean + sqrt(Mobileye_Grid{Idx_X, Idx_Y}.PosY_var*Confidence)*cos(theta), ...
    Mobileye_Grid{Idx_X, Idx_Y}.PosX_mean + sqrt(Mobileye_Grid{Idx_X, Idx_Y}.PosX_var*Confidence)*sin(theta), 'r');
plot(Mobileye_Grid{Idx_X, Idx_Y}.PosY_mean, Mobileye_Grid{Idx_X, Idx_Y}.PosX_mean,'ro');
xlabel('Y [m]'), ylabel('X [m]'); grid on; box on; axis equal;
hold off;

title(['Information in cell (',mat2str(Mobileye_GridX_Idx2meter(Idx_X)),', ',mat2str(Mobileye_GridY_Idx2meter(Idx_Y)),')']);

subplot(4,1,3);
% velocity X
hold on;
plot(0,0,'mp');
tmp_Vx = zeros(length(Mobileye_Grid_Object{Idx_X, Idx_Y}), 1);
for nObjIdx = 1:length(Mobileye_Grid_Object{Idx_X, Idx_Y})
    tmp_Vx(nObjIdx) = Mobileye_Grid_Object{Idx_X, Idx_Y}{nObjIdx}.Vx;
end
plot(tmp_Vx,zeros(length(tmp_Vx),1), 'b.');
plot(Mobileye_Grid{Idx_X, Idx_Y}.Vx_mean + sqrt(Mobileye_Grid{Idx_X, Idx_Y}.Vx_var*Confidence)*[-1, 1],[0 0],'r*-');
histogram(tmp_Vx);
plot(Mobileye_Grid{Idx_X, Idx_Y}.Vx_mean, 0,'ro'); 
xlabel('Vel_x [m/s]');
hold off; box on;

subplot(4,1,4);
% heading
hold on;
plot(0,0,'mp');
tmp_Heading = zeros(length(Mobileye_Grid_Object{Idx_X, Idx_Y}), 1);
for nObjIdx = 1:length(Mobileye_Grid_Object{Idx_X, Idx_Y})
    tmp_Heading(nObjIdx) =Mobileye_Grid_Object{Idx_X, Idx_Y}{nObjIdx}.Heading;
    
end
plot(tmp_Heading,zeros(length(tmp_Heading),1), 'b.');
plot(Mobileye_Grid{Idx_X, Idx_Y}.Heading_mean + sqrt(Mobileye_Grid{Idx_X, Idx_Y}.Heading_var*Confidence)*[-1, 1],[0 0],'r*-');
histogram(tmp_Heading);
plot(Mobileye_Grid{Idx_X, Idx_Y}.Heading_mean, 0,'ro'); 
xlabel('Heading [deg]');
hold off; box on;



end