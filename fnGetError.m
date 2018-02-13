function [ ErrX, ErrY ] = fnGetError( RefX, RefY, ObjX, ObjY )
    ErrX = ObjX - RefX;
    ErrY = ObjY - RefY;
end

