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
    
    Column = 4;
    Figure_FusionBoxRow = figure('Name','FusionBox error (Row)','NumberTitle','off','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     0 ...
        scrsz(3)/PlotArrSize(1)                scrsz(4) ]           );
    
    Column = 5;
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


[Val_LON,Idx_X] = min(abs(FusionBox_GridX_Idx2meter - tmp_y));
[Val_LAT,Idx_Y] = min(abs(FusionBox_GridY_Idx2meter - tmp_x));

if (Val_LON > GridSize_Lon) || (Val_LAT > GridSize_Lat); return; end
if isempty(FusionBox_Grid{Idx_X, Idx_Y}); return; end

% plot
figure(Figure_FusionBoxCell); clf;
subplot(5,1,[1 2]);
hold on;
% position
plot(0,0,'mp');
for nObjIdx = 1:length(FusionBox_Grid_Object{Idx_X, Idx_Y})
    plot(FusionBox_Grid_Object{Idx_X, Idx_Y}{nObjIdx}.PosY, FusionBox_Grid_Object{Idx_X, Idx_Y}{nObjIdx}.PosX, 'b.');
end
plot(FusionBox_Grid{Idx_X, Idx_Y}.PosY_mean, FusionBox_Grid{Idx_X, Idx_Y}.PosX_mean,'ro');
xlabel('lat [m]'), ylabel('lon [m]'); grid on; box on; axis equal;
hold off;

subplot(5,1,3);
% velocity X
hold on;
plot(0,0,'mp');
for nObjIdx = 1:length(FusionBox_Grid_Object{Idx_X, Idx_Y})
    plot(FusionBox_Grid_Object{Idx_X, Idx_Y}{nObjIdx}.Vx, 0, 'b.');
end
plot(FusionBox_Grid{Idx_X, Idx_Y}.Vx_mean, 0, 'ro'); 
ylabel('Vel_x [m/s]');
hold off;

subplot(5,1,4);
% velocity Y
hold on;
plot(0,0,'mp');
for nObjIdx = 1:length(FusionBox_Grid_Object{Idx_X, Idx_Y})
    plot(FusionBox_Grid_Object{Idx_X, Idx_Y}{nObjIdx}.Vy,0, 'b.');
end
plot(FusionBox_Grid{Idx_X, Idx_Y}.Vy_mean, 0,'ro'); 
ylabel('Vel_y [m/s]');
hold off;

subplot(5,1,5);
% heading
hold on;
plot(0,0,'mp');
for nObjIdx = 1:length(FusionBox_Grid_Object{Idx_X, Idx_Y})
    plot(FusionBox_Grid_Object{Idx_X, Idx_Y}{nObjIdx}.Heading,0, 'b.');
end
plot(FusionBox_Grid{Idx_X, Idx_Y}.Heading_mean, 0,'ro'); 
ylabel('Heading [deg]');
hold off;



end