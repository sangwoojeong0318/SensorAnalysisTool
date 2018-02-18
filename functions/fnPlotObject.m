function fnPlotObject(Object, marker)
    Valid = reshape(Object.Valid, [1, size(Object.Valid,1) * size(Object.Valid,2)]);
    Mask = Valid ~= 0;
    X = reshape(Object.X_m, [1, size(Object.X_m,1) * size(Object.X_m,2)]);
    Y = reshape(Object.Y_m, [1, size(Object.Y_m,1) * size(Object.Y_m,2)]);
    plot(X(Mask), Y(Mask), marker);
    
%     for idx = 1:1:size(Object.X_m,1)
%         Mask = Object.Valid(idx,:) ~= 0;
%         plot(Object.Y_m(idx,Mask), Object.X_m(idx,Mask), shape);
%     end
end
