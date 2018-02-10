function AssociatedObj = fnDataAssociation( Object, Reference)
    dist_thre =5;
    AssociatedObj.ID = zeros(1, size(Object.X_m, 2));
    AssociatedObj.Valid = logical(zeros(1, size(Object.X_m, 2)));
    AssociatedObj.X_m = zeros(1, size(Object.X_m, 2));
    AssociatedObj.Y_m = zeros(1, size(Object.X_m, 2));
    AssociatedObj.DistErr = zeros(1, size(Object.X_m, 2));
    
    for idxFrame = 1:1:size(Object.X_m, 2)
        mindist = 99999999;
        for idxObj = 1:1:size(Object.X_m, 1)
            if Object.Valid(idxObj, idxFrame) == false
                continue;
            end
            
            dist = sqrt((Object.X_m(idxObj, idxFrame) - Reference.X_local(idxFrame))^2 + ...
                (Object.Y_m(idxObj, idxFrame) - Reference.Y_local(idxFrame))^2);
            if dist < mindist && dist < dist_thre
                AssociatedObj.ID(idxFrame) = Object.ID(idxObj, idxFrame);
                AssociatedObj.Valid(idxFrame) = logical(Object.Valid(idxObj, idxFrame));
                AssociatedObj.X_m(idxFrame) = Object.X_m(idxObj, idxFrame);
                AssociatedObj.Y_m(idxFrame) = Object.Y_m(idxObj, idxFrame);
                AssociatedObj.DistErr(idxFrame) = dist;
                
                mindist = dist;
            end
        end
    end
end