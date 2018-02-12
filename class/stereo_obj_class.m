classdef stereo_obj_class < object_class
    properties
        disparity = [];
    end
    methods
        function obj = stereo_obj_class(id)
            obj.id = id;
        end
    end
end