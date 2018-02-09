function fnPlotObject(Object, shape)
    for idx = 1:1:size(Object.X_m,1)
        Mask = Object.Valid(idx,:) ~= 0;
        plot(Object.Y_m(idx,Mask), Object.X_m(idx,Mask), shape);
    end
end
