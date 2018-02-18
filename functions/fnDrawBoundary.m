function [Fov_left, Fov_right] = fnDrawBoundary( Object )
tmpX = reshape(Object.X_m, [1, size(Object.X_m,1) * size(Object.X_m,2)]);
tmpY = reshape(Object.Y_m, [1, size(Object.Y_m,1) * size(Object.Y_m,2)]);
tmpValid = reshape(Object.Valid, [1, size(Object.Valid,1) * size(Object.Valid,2)]);
tmpValid_Idx = tmpValid ~= 0;
Valid_X = tmpX(tmpValid_Idx); Valid_X(length(Valid_X) + 1) = 0;
Valid_Y = tmpY(tmpValid_Idx); Valid_Y(length(Valid_Y) + 1) = 0;

StereoBoundary = boundary(Valid_X', Valid_Y',0.01);
Bnd_Y = Valid_Y(StereoBoundary);
Bnd_X = Valid_X(StereoBoundary);

atanvalue = atand(Bnd_Y ./ Bnd_X);
idx = abs(atanvalue) ~= 90;

ValidBnd_X = Bnd_X(idx);
ValidBnd_Y = Bnd_Y(idx);

[Fov_left, idx_max] = max(atanvalue(idx));
[Fov_right, idx_min] = min(atanvalue(idx));

% Draw boundary
% plot(Bnd_X, Bnd_Y,'black.-','LineWidth',1);
% fill(Bnd_X, Bnd_Y, [1 0.5 0], 'facealpha',0.1);

% Draw FOV
Draw_X = 20;
Draw_Y_left = Draw_X * tand(Fov_left);
Draw_Y_right = Draw_X * tand(Fov_right);

fill([0, Draw_X, Draw_X, 0], [0, Draw_Y_left, Draw_Y_right, 0], [1 0.5 0], 'facealpha',0.1, 'EdgeColor', [1, 1, 1]);
plot([0,Draw_X], [0, Draw_Y_left], 'r-', 'Linewidth', 2);
plot([0,Draw_X], [0, Draw_Y_right], 'r-', 'Linewidth', 2);

end

