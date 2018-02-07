function Callback_Mobileyegrid(handle, event, handles)

% select grid
pt = get(gca,'currentpoint');

tmp_x = pt(1,1);
tmp_y = pt(1,2);

try 
    Figure_MobileyeCell = evalin('base','Figure_MobileyeCell'); 
catch 
    Figure_MobileyeCell = figure;
    assignin('base','Figure_MobileyeCell',Figure_MobileyeCell);
end

% Data aquisition
Mobileye_Grid = evalin('base','Mobileye_Grid'); 
Mobileye_Grid_Object = evalin('base','Mobileye_Grid_Object'); 

Mobileye_GridX_Idx2meter = evalin('base','Mobileye_GridX_Idx2meter'); 
Mobileye_GridY_Idx2meter = evalin('base','Mobileye_GridY_Idx2meter'); 

GridSize_Lat = evalin('base','GridSize_Lat'); 
GridSize_Lon = evalin('base','GridSize_Lon'); 


[Val_LON,Idx_X] = min(abs(Mobileye_GridX_Idx2meter - tmp_y));
[Val_LAT,Idx_Y] = min(abs(Mobileye_GridY_Idx2meter - tmp_x));

if (Val_LON > GridSize_Lon) || (Val_LAT > GridSize_Lat); return; end
if isempty(Mobileye_Grid{Idx_X, Idx_Y}); return; end

% plot
figure(Figure_MobileyeCell); clf;
subplot(4,1,[1 2]);
hold on;
% position
plot(0,0,'mp');
for nObjIdx = 1:length(Mobileye_Grid_Object{Idx_X, Idx_Y})
    plot(Mobileye_Grid_Object{Idx_X, Idx_Y}{nObjIdx}.PosY, Mobileye_Grid_Object{Idx_X, Idx_Y}{nObjIdx}.PosX, 'b.');
end
plot(Mobileye_Grid{Idx_X, Idx_Y}.PosY_mean, Mobileye_Grid{Idx_X, Idx_Y}.PosX_mean,'ro');
xlabel('lat [m]'), ylabel('lon [m]'); grid on; box on; axis equal;
hold off;

subplot(4,1,3);
% velocity X
hold on;
plot(0,0,'mp');
for nObjIdx = 1:length(Mobileye_Grid_Object{Idx_X, Idx_Y})
    plot(Mobileye_Grid_Object{Idx_X, Idx_Y}{nObjIdx}.Vx,0, 'b.');
end
plot(Mobileye_Grid{Idx_X, Idx_Y}.Vx_mean, 0,'ro'); 
ylabel('Vel_x [m/s]');
hold off;

subplot(4,1,4);
% heading
hold on;
plot(0,0,'mp');
for nObjIdx = 1:length(Mobileye_Grid_Object{Idx_X, Idx_Y})
    plot(Mobileye_Grid_Object{Idx_X, Idx_Y}{nObjIdx}.Heading,0, 'b.');
end
plot(Mobileye_Grid{Idx_X, Idx_Y}.Heading_mean, 0,'ro'); 
ylabel('Heading [deg]');
hold off;



end