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
        
        %% constructor
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
            %   - That consecutive vertices aren't repetitions.
            %   - That the edges of the polygon don't cross.
            %   - That the polygon is convex.
            
            obj.x = x(:);
            obj.y = y(:);
            obj.z = z(:);
        end % function Polygon
        
        %% methods defined in separate files
        vertices = toMatrix(obj)
        
        [a, b, origin, axisA, axisB] = to2D(obj)
        
        % I recommend using getPlane instead of getPlane_old.
        [plane, axisA, axisB] = getPlane(obj)
        [point, normal] = getPlane_old(obj)
        
        a = area(obj)
    end
    
end

