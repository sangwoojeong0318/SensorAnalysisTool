%% Sourecode of Main Grid Approximation

switch(ans_sensor)
    case SensorType.Delphi
        Selected_Grid = Delphi_Grid;
        X_Idx2meter = Delphi_GridX_Idx2meter;
        Y_Idx2meter = Delphi_GridY_Idx2meter;
        X_meter2Idx = Delphi_GridX_meter2Idx;
        Y_meter2Idx = Delphi_GridY_meter2Idx;
        
    case SensorType.Mobileye
        Selected_Grid = Mobileye_Grid;
        X_Idx2meter = Mobileye_GridX_Idx2meter;
        Y_Idx2meter = Mobileye_GridY_Idx2meter;
        X_meter2Idx = Mobileye_GridX_meter2Idx;
        Y_meter2Idx = Mobileye_GridY_meter2Idx;
        
    case SensorType.FusionBox
        Selected_Grid = FusionBox_Grid;
        X_Idx2meter = FusionBox_GridX_Idx2meter;
        Y_Idx2meter = FusionBox_GridY_Idx2meter;
        X_meter2Idx = FusionBox_GridX_meter2Idx;
        Y_meter2Idx = FusionBox_GridY_meter2Idx;
        
    otherwise
        return;
end

Grid_Init.X = NaN(length(X_Idx2meter), length(Y_Idx2meter));
Grid_Init.Y = NaN(length(X_Idx2meter), length(Y_Idx2meter));
Grid_Init.PosX_mean = NaN(length(X_Idx2meter), length(Y_Idx2meter));
Grid_Init.PosY_mean = NaN(length(X_Idx2meter), length(Y_Idx2meter));

Grid_Init.R_mean = NaN(length(X_Idx2meter), length(Y_Idx2meter));
Grid_Init.Theta_mean = NaN(length(X_Idx2meter), length(Y_Idx2meter));

Grid_Init.Vx_mean = NaN(length(X_Idx2meter), length(Y_Idx2meter));
Grid_Init.Vy_mean = NaN(length(X_Idx2meter), length(Y_Idx2meter));
Grid_Init.Heading_mean = NaN(length(X_Idx2meter), length(Y_Idx2meter));
Grid_Init.PosX_var = NaN(length(X_Idx2meter), length(Y_Idx2meter));
Grid_Init.PosY_var = NaN(length(X_Idx2meter), length(Y_Idx2meter));
Grid_Init.Vx_var = NaN(length(X_Idx2meter), length(Y_Idx2meter));
Grid_Init.Vy_var = NaN(length(X_Idx2meter), length(Y_Idx2meter));
Grid_Init.Heading_var = NaN(length(X_Idx2meter), length(Y_Idx2meter));
%%  1.2. Fusion box grid parsing
fprintf('  - Fusion box grid information parsing... ');
Grid = Grid_Init;
[Grid.Y, Grid.X] = meshgrid(Y_Idx2meter,X_Idx2meter);
IdxRange_Y = NaN(length(X_Idx2meter),2);
pixel_list = zeros(0,3);
r_list = zeros(0,1);
theta_list = zeros(0,1);
x_list = zeros(0,1);
y_list = zeros(0,1);
Vx_list = zeros(0,1);
Vy_list = zeros(0,1);
Heading_list = zeros(0,1);
x_var_list = zeros(0,1);
y_var_list = zeros(0,1);
Vx_var_list = zeros(0,1);
Vy_var_list = zeros(0,1);
Heading_var_list = zeros(0,1);


for nXIdx = 1:length(X_Idx2meter)
    
    bStartFlag = false;
    for nYIdx = 1:length(Y_Idx2meter)
        if ~isempty(Selected_Grid{nXIdx, nYIdx})
            %% Data parsing
            if bStartFlag == false
                % Estimate the start index
                IdxRange_Y(nXIdx,1) = nYIdx;
                bStartFlag = true;
            end
            % Reference position
            tmp_RefX = X_Idx2meter(nXIdx);
            tmp_RefY = Y_Idx2meter(nYIdx);
            tmp_RefR = sqrt(tmp_RefX^2 + tmp_RefY^2);
            tmp_RefTheta = atan2d(tmp_RefY , tmp_RefX);
            
            Grid.PosX_mean(nXIdx, nYIdx) = Selected_Grid{nXIdx, nYIdx}.PosX_mean;
            Grid.PosY_mean(nXIdx, nYIdx) = Selected_Grid{nXIdx, nYIdx}.PosY_mean;
            
            % polar coordinate
            tmp_R = sqrt((tmp_RefX+Grid.PosX_mean(nXIdx, nYIdx))^2 + (tmp_RefY+Grid.PosY_mean(nXIdx, nYIdx))^2);
            tmp_Theta =  atan2d(tmp_RefY+Grid.PosY_mean(nXIdx, nYIdx), tmp_RefX+Grid.PosX_mean(nXIdx, nYIdx));
            Grid.R_mean(nXIdx, nYIdx) = tmp_RefR - tmp_R;
            
            tmp_theta_err = mod(tmp_RefTheta - tmp_Theta,360);
            if(tmp_theta_err > 180); tmp_theta_err = tmp_theta_err -360; end
            Grid.Theta_mean(nXIdx, nYIdx) = tmp_theta_err;
            
            Grid.Vx_mean(nXIdx, nYIdx) = Selected_Grid{nXIdx, nYIdx}.Vx_mean;
            if ans_sensor ~= SensorType.Mobileye; Grid.Vy_mean(nXIdx, nYIdx) = Selected_Grid{nXIdx, nYIdx}.Vy_mean; end
            Grid.Heading_mean(nXIdx, nYIdx) = Selected_Grid{nXIdx, nYIdx}.Heading_mean;
            Grid.PosX_var(nXIdx, nYIdx) = Selected_Grid{nXIdx, nYIdx}.PosX_var;
            Grid.PosY_var(nXIdx, nYIdx) = Selected_Grid{nXIdx, nYIdx}.PosY_var;
            Grid.Vx_var(nXIdx, nYIdx) = Selected_Grid{nXIdx, nYIdx}.Vx_var;
            if ans_sensor ~= SensorType.Mobileye; Grid.Vy_var(nXIdx, nYIdx) = Selected_Grid{nXIdx, nYIdx}.Vy_var; end
            Grid.Heading_var(nXIdx, nYIdx) = Selected_Grid{nXIdx, nYIdx}.Heading_var;
            
            IdxRange_Y(nXIdx,2) = nYIdx;
            
            %% data for RMS plane approximation
            pixel_list(size(pixel_list,1)+1,:) = [tmp_RefX, tmp_RefY, 1];
            r_list(size(r_list,1)+1,:) = Grid.R_mean(nXIdx, nYIdx);
            theta_list(size(theta_list,1)+1,:) = Grid.Theta_mean(nXIdx, nYIdx);
            x_list(size(x_list,1)+1,:) = Grid.PosX_mean(nXIdx, nYIdx);
            y_list(size(y_list,1)+1,:) = Grid.PosY_mean(nXIdx, nYIdx);
            Vx_list(size(Vx_list,1)+1,:) = Grid.Vx_mean(nXIdx, nYIdx);
            if ans_sensor ~= SensorType.Mobileye; Vy_list(size(Vy_list,1)+1,:) = Grid.Vy_mean(nXIdx, nYIdx); end
            Heading_list(size(Heading_list,1)+1,:) = Grid.Heading_mean(nXIdx, nYIdx);
            x_var_list(size(x_var_list,1)+1,:) = Grid.PosX_var(nXIdx, nYIdx);
            y_var_list(size(y_var_list,1)+1,:) = Grid.PosY_var(nXIdx, nYIdx);
            Vx_var_list(size(Vx_var_list,1)+1,:) = Grid.Vx_var(nXIdx, nYIdx);
            if ans_sensor ~= SensorType.Mobileye; Vy_var_list(size(Vy_var_list,1)+1,:) = Grid.Vy_var(nXIdx, nYIdx); end
            Heading_var_list(size(Heading_var_list,1)+1,:) = Grid.Heading_var(nXIdx, nYIdx);
        end
        
    end
end
fprintf('[Complete]\n');
%% [Step 2] Approximation
fprintf('  - Data Approximating... ');
%%  2.1. RMS approximation
opts = fitoptions( 'Method', 'LinearLeastSquares' ,'Robust','Bisquare');
SourceIdx_X = pixel_list(:,1);
SourceIdx_Y = pixel_list(:,2);

[fitresult, ~] = fit( pixel_list(:,1:2), r_list,  'poly11', opts );
Parm_r = [fitresult.p10, fitresult.p01, fitresult.p00];

[fitresult, ~] = fit( pixel_list(:,1:2), theta_list,  'poly11', opts );
Parm_theta = [fitresult.p10, fitresult.p01, fitresult.p00];

[fitresult, ~] = fit( pixel_list(:,1:2), x_list,  'poly11', opts );
Parm_x = [fitresult.p10, fitresult.p01, fitresult.p00];

[fitresult, ~] = fit( pixel_list(:,1:2), y_list,  'poly11', opts );
Parm_y = [fitresult.p10, fitresult.p01, fitresult.p00];

[fitresult, ~] = fit( pixel_list(:,1:2), Vx_list,  'poly11', opts );
Parm_Vx = [fitresult.p10, fitresult.p01, fitresult.p00];

if ans_sensor ~= SensorType.Mobileye
    [fitresult, ~] = fit( pixel_list(:,1:2), Vy_list,  'poly11', opts );
    Parm_Vy = [fitresult.p10, fitresult.p01, fitresult.p00];
end


[fitresult, ~] = fit( pixel_list(:,1:2), Heading_list,  'poly11', opts );
Parm_Heading = [fitresult.p10, fitresult.p01, fitresult.p00];

% Covariance
opts.Lower = [-Inf 0 -Inf];
[fitresult, ~] = fit( pixel_list(:,1:2), x_var_list,  'poly11', opts );
[fit_x_var, ~] = fit( pixel_list(:,1:2), x_var_list, 'lowess', 'Robust', 'Bisquare', 'Normalize', 'on' );
Parm_x_var = [fitresult.p10, fitresult.p01, fitresult.p00];

[fitresult, ~] = fit( pixel_list(:,1:2), y_var_list,  'poly11', opts );
[fit_y_var, ~] = fit( pixel_list(:,1:2), y_var_list, 'lowess', 'Robust', 'Bisquare', 'Normalize', 'on' );
Parm_y_var = [fitresult.p10, fitresult.p01, fitresult.p00];

[fitresult, ~] = fit( pixel_list(:,1:2), Vx_var_list,  'poly11', opts );
[fit_Vx_var, ~] = fit( pixel_list(:,1:2), Vx_var_list, 'lowess', 'Robust', 'Bisquare', 'Normalize', 'on' );
Parm_Vx_var = [fitresult.p10, fitresult.p01, fitresult.p00];

if ans_sensor ~= SensorType.Mobileye
    [fitresult, ~] = fit( pixel_list(:,1:2), Vy_var_list,  'poly11', opts );
    [fit_Vy_var, ~] = fit( pixel_list(:,1:2), Vy_var_list, 'lowess', 'Robust', 'Bisquare', 'Normalize', 'on' );
    Parm_Vy_var = [fitresult.p10, fitresult.p01, fitresult.p00];
end

[fitresult, ~] = fit( pixel_list(:,1:2), Heading_var_list,  'poly11', opts );
[fit_Heading_var, ~] = fit( pixel_list(:,1:2), Heading_var_list, 'lowess', 'Robust', 'Bisquare', 'Normalize', 'on' );
Parm_Heading_var = [fitresult.p10, fitresult.p01, fitresult.p00];
%%  2.2. Plain info estimation
Grid_Approx = Grid;
for nXIdx = 1:length(X_Idx2meter)
    for nYIdx = 1:length(Y_Idx2meter)
        if (nYIdx >= IdxRange_Y(nXIdx,1)) && (nYIdx <= IdxRange_Y(nXIdx,2))
            % Reference position
            tmp_RefX = X_Idx2meter(nXIdx);
            tmp_RefY = Y_Idx2meter(nYIdx);
            
            % value estimation
            Grid_Approx.R_mean(nXIdx, nYIdx) = Parm_r(1)*tmp_RefX + Parm_r(2)*tmp_RefY + Parm_r(3);
            Grid_Approx.Theta_mean(nXIdx, nYIdx) = Parm_theta(1)*tmp_RefX + Parm_theta(2)*tmp_RefY + Parm_theta(3);
            Grid_Approx.PosX_mean(nXIdx, nYIdx) = Parm_x(1)*tmp_RefX + Parm_x(2)*tmp_RefY + Parm_x(3);
            Grid_Approx.PosY_mean(nXIdx, nYIdx) = Parm_y(1)*tmp_RefX + Parm_y(2)*tmp_RefY + Parm_y(3);
            Grid_Approx.Vx_mean(nXIdx, nYIdx) = Parm_Vx(1)*tmp_RefX + Parm_Vx(2)*tmp_RefY + Parm_Vx(3);
            if ans_sensor ~= SensorType.Mobileye; Grid_Approx.Vy_mean(nXIdx, nYIdx) = Parm_Vy(1)*tmp_RefX + Parm_Vy(2)*tmp_RefY + Parm_Vy(3); end
            Grid_Approx.Heading_mean(nXIdx, nYIdx) = Parm_Heading(1)*tmp_RefX + Parm_Heading(2)*tmp_RefY + Parm_Heading(3);
            
            Grid_Approx.PosX_var(nXIdx, nYIdx) = fit_x_var(tmp_RefX, tmp_RefY);
            Grid_Approx.PosY_var(nXIdx, nYIdx) = fit_y_var(tmp_RefX, tmp_RefY);
            Grid_Approx.Vx_var(nXIdx, nYIdx) = fit_Vx_var(tmp_RefX, tmp_RefY);
            if ans_sensor ~= SensorType.Mobileye; Grid_Approx.Vy_var(nXIdx, nYIdx) = fit_Vy_var(tmp_RefX, tmp_RefY); end
            Grid_Approx.Heading_var(nXIdx, nYIdx) = fit_Heading_var(tmp_RefX, tmp_RefY);
            
%             Grid_Approx.PosX_var(nXIdx, nYIdx) = Parm_x_var(1)*tmp_RefX + Parm_x_var(2)*tmp_RefY + Parm_x_var(3);
%             Grid_Approx.PosY_var(nXIdx, nYIdx) = Parm_y_var(1)*tmp_RefX + Parm_y_var(2)*tmp_RefY + Parm_y_var(3);
%             Grid_Approx.Vx_var(nXIdx, nYIdx) = Parm_Vx_var(1)*tmp_RefX + Parm_Vx_var(2)*tmp_RefY + Parm_Vx_var(3);
%             if ans_sensor ~= SensorType.Mobileye; Grid_Approx.Vy_var(nXIdx, nYIdx) = Parm_Vy_var(1)*tmp_RefX + Parm_Vy_var(2)*tmp_RefY + Parm_Vy_var(3); end
%             Grid_Approx.Heading_var(nXIdx, nYIdx) = Parm_Heading_var(1)*tmp_RefX + Parm_Heading_var(2)*tmp_RefY + Parm_Heading_var(3);
        end
    end
end
fprintf('[Complete]\n');
%% [Step 3] Plot
if IsErrorModelExtraction == false
    %%  3.1. Plot configuration
    scrsz = get(0,'ScreenSize');
    PlotArrSize = [3 4]; % Plot arrange size
    Plot_ColorTable % Load the plot color code
    %%  3.2 Plot
    %%   3.2.1. R
    Row = 1;
    Column = 1;
    figure('Name','r','NumberTitle','off','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     scrsz(4)/PlotArrSize(2)*(PlotArrSize(2)-Row) ...
        scrsz(3)/PlotArrSize(1)                scrsz(4)/PlotArrSize(2) ]           );
    
    hold on;
    mesh(Grid.X, Grid.Y, Grid.R_mean);
    surf(Grid_Approx.X, Grid_Approx.Y, Grid_Approx.R_mean);
    hold off; box on; grid on;
    legend(['aX+bY+c / a: ',num2str(Parm_r(1)),', b: ', num2str(Parm_r(2)),', c: ', num2str(Parm_r(3))]);
    xlabel('X [m]'); ylabel('Y [m]'); zlabel('R [m]');
    %%   3.2.2. Theta
    Row = 1;
    Column = 2;
    figure('Name','theta','NumberTitle','off','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     scrsz(4)/PlotArrSize(2)*(PlotArrSize(2)-Row) ...
        scrsz(3)/PlotArrSize(1)                scrsz(4)/PlotArrSize(2) ]           );
    
    hold on;
    mesh(Grid.X, Grid.Y, Grid.Theta_mean);
    surf(Grid_Approx.X, Grid_Approx.Y, Grid_Approx.Theta_mean);
    hold off; box on; grid on;
    legend(['aX+bY+c / a: ',num2str(Parm_theta(1)),', b: ', num2str(Parm_theta(2)),', c: ', num2str(Parm_theta(3))]);
    xlabel('X [m]'); ylabel('Y [m]'); zlabel('Theta [deg]');
    %%   3.2.3. X
    Row = 1;
    Column = 3;
    figure('Name','X','NumberTitle','off','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     scrsz(4)/PlotArrSize(2)*(PlotArrSize(2)-Row) ...
        scrsz(3)/PlotArrSize(1)                scrsz(4)/PlotArrSize(2) ]           );
    
    hold on;
    mesh(Grid.X, Grid.Y, Grid.PosX_mean);
    surf(Grid_Approx.X, Grid_Approx.Y, Grid_Approx.PosX_mean);
    hold off; box on; grid on;
    legend(['aX+bY+c / a: ',num2str(Parm_x(1)),', b: ', num2str(Parm_x(2)),', c: ', num2str(Parm_x(3))]);
    xlabel('X [m]'); ylabel('Y [m]'); zlabel('X [m]');
    %%   3.2.4. Y
    Row = 2;
    Column = 1;
    figure('Name','Y','NumberTitle','off','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     scrsz(4)/PlotArrSize(2)*(PlotArrSize(2)-Row) ...
        scrsz(3)/PlotArrSize(1)                scrsz(4)/PlotArrSize(2) ]           );
    
    hold on;
    mesh(Grid.X, Grid.Y, Grid.PosY_mean);
    surf(Grid_Approx.X, Grid_Approx.Y, Grid_Approx.PosY_mean);
    hold off; box on; grid on;
    legend(['aX+bY+c / a: ',num2str(Parm_y(1)),', b: ', num2str(Parm_y(2)),', c: ', num2str(Parm_y(3))]);
    xlabel('X [m]'); ylabel('Y [m]'); zlabel('Y [m]');
    %%   3.2.5. Vx
    Row = 2;
    Column = 2;
    figure('Name','V_x','NumberTitle','off','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     scrsz(4)/PlotArrSize(2)*(PlotArrSize(2)-Row) ...
        scrsz(3)/PlotArrSize(1)                scrsz(4)/PlotArrSize(2) ]           );
    
    hold on;
    mesh(Grid.X, Grid.Y, Grid.Vx_mean);
    surf(Grid_Approx.X, Grid_Approx.Y, Grid_Approx.Vx_mean);
    hold off; box on; grid on;
    legend(['aX+bY+c / a: ',num2str(Parm_Vx(1)),', b: ', num2str(Parm_Vx(2)),', c: ', num2str(Parm_Vx(3))]);
    xlabel('X [m]'); ylabel('Y [m]'); zlabel('V_x [m/s]');
    %%   3.2.6. Vy
    if ans_sensor ~= SensorType.Mobileye
        Row = 2;
        Column = 3;
        figure('Name','V_y','NumberTitle','off','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     scrsz(4)/PlotArrSize(2)*(PlotArrSize(2)-Row) ...
            scrsz(3)/PlotArrSize(1)                scrsz(4)/PlotArrSize(2) ]           );
        
        hold on;
        mesh(Grid.X, Grid.Y, Grid.Vy_mean);
        surf(Grid_Approx.X, Grid_Approx.Y, Grid_Approx.Vy_mean);
        hold off; box on; grid on;
        legend(['aX+bY+c / a: ',num2str(Parm_Vy(1)),', b: ', num2str(Parm_Vy(2)),', c: ', num2str(Parm_Vy(3))]);
        xlabel('X [m]'); ylabel('Y [m]'); zlabel('V_y [m/s]');
    end
    %%   3.2.7. Heading
    Row = 3;
    Column = 1;
    figure('Name','Heading','NumberTitle','off','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     scrsz(4)/PlotArrSize(2)*(PlotArrSize(2)-Row) ...
        scrsz(3)/PlotArrSize(1)                scrsz(4)/PlotArrSize(2) ]           );
    
    hold on;
    mesh(Grid.X, Grid.Y, Grid.Heading_mean);
    surf(Grid_Approx.X, Grid_Approx.Y, Grid_Approx.Heading_mean);
    hold off; box on; grid on;
    legend(['aX+bY+c / a: ',num2str(Parm_Heading(1)),', b: ', num2str(Parm_Heading(2)),', c: ', num2str(Parm_Heading(3))]);
    xlabel('X [m]'); ylabel('Y [m]'); zlabel('Heading [deg]');
    %%   3.2.8. X variance
    Row = 3;
    Column = 2;
    figure('Name','X (variance)','NumberTitle','off','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     scrsz(4)/PlotArrSize(2)*(PlotArrSize(2)-Row) ...
        scrsz(3)/PlotArrSize(1)                scrsz(4)/PlotArrSize(2) ]           );
    
    hold on;
    mesh(Grid.X, Grid.Y, Grid.PosX_var);
    surf(Grid_Approx.X, Grid_Approx.Y, Grid_Approx.PosX_var);
    hold off; box on; grid on;
    legend(['aX+bY+c / a: ',num2str(Parm_x_var(1)),', b: ', num2str(Parm_x_var(2)),', c: ', num2str(Parm_x_var(3))]);
    xlabel('X [m]'); ylabel('Y [m]'); zlabel('X var [m^2]');
    %%   3.2.9. Y variance
    Row = 3;
    Column = 3;
    figure('Name','Y (variance)','NumberTitle','off','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     scrsz(4)/PlotArrSize(2)*(PlotArrSize(2)-Row) ...
        scrsz(3)/PlotArrSize(1)                scrsz(4)/PlotArrSize(2) ]           );
    
    hold on;
    mesh(Grid.X, Grid.Y, Grid.PosY_var);
    surf(Grid_Approx.X, Grid_Approx.Y, Grid_Approx.PosY_var);
    hold off; box on; grid on;
    legend(['aX+bY+c / a: ',num2str(Parm_y_var(1)),', b: ', num2str(Parm_y_var(2)),', c: ', num2str(Parm_y_var(3))]);
    xlabel('X [m]'); ylabel('Y [m]'); zlabel('Y var [m^2]');
    %%   3.2.10. Vx variance
    Row = 4;
    Column = 1;
    figure('Name','V_x (variance)','NumberTitle','off','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     scrsz(4)/PlotArrSize(2)*(PlotArrSize(2)-Row) ...
        scrsz(3)/PlotArrSize(1)                scrsz(4)/PlotArrSize(2) ]           );
    
    hold on;
    mesh(Grid.X, Grid.Y, Grid.Vx_var);
    surf(Grid_Approx.X, Grid_Approx.Y, Grid_Approx.Vx_var);
    hold off; box on; grid on;
    legend(['aX+bY+c / a: ',num2str(Parm_Vx_var(1)),', b: ', num2str(Parm_Vx_var(2)),', c: ', num2str(Parm_Vx_var(3))]);
    xlabel('X [m]'); ylabel('Y [m]'); zlabel('V_x var [{m/s}^2]');
    %%   3.2.11. Vy variance
    if ans_sensor ~= SensorType.Mobileye
        Row = 4;
        Column = 2;
        figure('Name','V_y (variance)','NumberTitle','off','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     scrsz(4)/PlotArrSize(2)*(PlotArrSize(2)-Row) ...
            scrsz(3)/PlotArrSize(1)                scrsz(4)/PlotArrSize(2) ]           );
        
        hold on;
        mesh(Grid.X, Grid.Y, Grid.Vy_var);
        surf(Grid_Approx.X, Grid_Approx.Y, Grid_Approx.Vy_var);
        hold off; box on; grid on;
        legend(['aX+bY+c / a: ',num2str(Parm_Vy_var(1)),', b: ', num2str(Parm_Vy_var(2)),', c: ', num2str(Parm_Vy_var(3))]);
        xlabel('X [m]'); ylabel('Y [m]'); zlabel('V_y var [{m/s}^2]');
    end
    %%   3.2.12. Heading variance
    Row = 4;
    Column = 3;
    figure('Name','Heading (variance)','NumberTitle','off','Position',[ scrsz(3)/PlotArrSize(1)*(Column-1)     scrsz(4)/PlotArrSize(2)*(PlotArrSize(2)-Row) ...
        scrsz(3)/PlotArrSize(1)                scrsz(4)/PlotArrSize(2) ]           );
    
    hold on;
    mesh(Grid.X, Grid.Y, Grid.Heading_var);
    surf(Grid_Approx.X, Grid_Approx.Y, Grid_Approx.Heading_var);
    hold off; box on; grid on;
    legend(['aX+bY+c / a: ',num2str(Parm_Heading_var(1)),', b: ', num2str(Parm_Heading_var(2)),', c: ', num2str(Parm_Heading_var(3))]);
    xlabel('X [m]'); ylabel('Y [m]'); zlabel('Heading var [deg^2]');
end
%% Data output
ConfigFile_path = [file_path, '\Sensor_Config.ini'];
% if exist(ConfigFile_path,'File')
%     delete(ConfigFile_path)
% end


File = fopen(ConfigFile_path,'a');
SensorName = '';
switch(ans_sensor)
    case SensorType.Delphi
        SensorName = 'Delphi';
    case SensorType.Mobileye
        SensorName = 'Mobileye';
    case SensorType.FusionBox
        SensorName = 'FusionBox';
        
        
    otherwise
        return;
end
fprintf(File,'\r\n[%s]\r\n',SensorName);
fprintf(File,';%s\r\n',datetime);
fprintf(File,'r_offset = %.4f\r\n',Parm_r(3));
fprintf(File,'theta_offset = %.4f\r\n',Parm_theta(3));
fprintf(File,'Vx_offset = %.4f\r\n',Parm_Vx(3));
if ans_sensor ~= SensorType.Mobileye; fprintf(File,'Vy_offset = %.4f\r\n',Parm_Vy(3)); end
fprintf(File,'Heading_offset = %.4f\r\n\r\n',Parm_Heading(3));

fprintf(File,'CellSize_Lat = %.2f\r\n',Y_Idx2meter(2)-Y_Idx2meter(1));
fprintf(File,'CellSize_Lon = %.2f\r\n',X_Idx2meter(2)-X_Idx2meter(1));
fprintf(File,'Origin_RowIdx = %d\r\n',X_meter2Idx(0));
fprintf(File,'Origin_ColIdx = %d\r\n\r\n',Y_meter2Idx(0));


if ans_sensor ~= SensorType.Mobileye
    List_VarName = {'PosX_var','PosY_var','Vx_var','Vy_var','Heading_var'};
else
    List_VarName = {'PosX_var','PosY_var','Vx_var','Heading_var'};
end

VarModel = Grid_Approx.PosX_var;
for nIndex = 1:length(List_VarName)
    VariableName = List_VarName{nIndex};
    VarModel_path = ['VarModel\',SensorName,'_',VariableName,'.png'];
    eval(['VarModel = Grid_Approx.',VariableName,';']);
    VarModel(isnan(VarModel)) = 0;
    var_max = max(max(VarModel));
    VarModel = VarModel / var_max;
    imwrite(VarModel,[file_path,'\',VarModel_path(1:end)],'BitDepth',16);
    fprintf(File,'%s_max = %.4f\r\n',List_VarName{nIndex},var_max);
    fprintf(File,'%s = %s\r\n',List_VarName{nIndex},VarModel_path);
end

fclose(File);
