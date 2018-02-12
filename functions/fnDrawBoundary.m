function fnDrawBoundary( Object )
tmpX = reshape(Object.X_m, [1, size(Object.X_m,1) * size(Object.X_m,2)]);
tmpY = reshape(Object.Y_m, [1, size(Object.Y_m,1) * size(Object.Y_m,2)]);
tmpValid = reshape(Object.Valid, [1, size(Object.Valid,1) * size(Object.Valid,2)]);
tmpValid_Idx = tmpValid ~= 0;
Valid_X = tmpX(tmpValid_Idx); Valid_X(length(Valid_X) + 1) = 0;
Valid_Y = tmpY(tmpValid_Idx); Valid_Y(length(Valid_Y) + 1) = 0;

StereoBoundary = boundary(Valid_X', Valid_Y',0.01);
plot(Valid_Y(StereoBoundary), Valid_X(StereoBoundary),'black','LineWidth',2);

end

