classdef object_class
    properties
        time = [];
        id = [];
        pos_x_m = [];
        pos_y_m = [];
        heading_angle_rad = [];
        width = [];
        length = [];
    end
    methods
        function obj = object_class(id)
            obj.id = id;
        end
        function obj = add_data(obj, time, pos_x, pos_y, heading_angle_rad, width, length)
            obj.time(end+1) = time;
            obj.pos_x_m(end+1,:) = [time, pos_x];
            obj.pos_y_m(end+1,:) = [time, pos_y];
            obj.heading_angle_rad(end+1,:) = [time, heading_angle_rad];
            obj.width(end+1,:) = [time, width];
            obj.length(end+1,:) = [time, length];
        end             
    end
end

