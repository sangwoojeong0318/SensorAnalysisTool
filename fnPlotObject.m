function fnPlotObject(Object, shape)
    for idx = 1:1:size(Object.X,1)
        Mask = Object.Valid(idx,:) ~= 0;
        plot(Object.Y(idx,Mask), Object.X(idx,Mask), shape);
    end
end
