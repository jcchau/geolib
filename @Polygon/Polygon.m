classdef Polygon
    %Polygon A flat polygon in 3D space.
    %   Represents a polygon.
    
    % SetAccess = private to avoid bypassing error checking
    properties (SetAccess = private)
        x
        y
        z
    end
    
    methods
        function obj = Polygon(x, y, z)
            % Only basic error-checking
            if(length(x) ~= length(y) || length(x) ~= length(z))
                error('Error: Number vertices in x, y, and z dimensions don''t match.');
            end
            if(length(x)<3)
                error('Error: Not enough vertices to define a polygon.');
            end
            % Additional error checking omitted for performance:
            %   - That the points don't all lie on a line.
            %   - That all of the points are on the same plane.
            
            obj.x = x(:);
            obj.y = y(:);
            obj.z = z(:);
        end
        
        vertices = toMatrix(obj)
        
        [point, normal] = getPlane(obj)
        
        a = area(obj)
    end
    
end

