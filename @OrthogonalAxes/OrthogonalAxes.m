classdef OrthogonalAxes
    % ORTHOGONALAXES A pair of orthogonal axes on a plane in 3D space.
    %   The axes are internally represented by a pair of orthonormal
    %   vectors. 
    %
    %   Note that to properly validate the axes (and to ensure that they
    %   are orthogonal to each other), the axes are immutable.  
    
    properties(Constant)
        PARALLEL_TOLERANCE = Plane.PARALLEL_TOLERANCE;
    end % properties(Constant)
    
    properties(SetAccess = immutable)
        % Since these local axes will likely be defined in a global 3D
        % coordinate space (where the global axes are called x, y, and z),
        % it would be confusing to call the axes x and y here.  
        %
        % Since this class is designed to represent the axes with respect
        % to a plane, call the plane's 2D axes "horizontal" and "vertical".
        % This will help avoid ambiguity or confusion when converting
        % between plane coordinates and row/column indices.  
        %
        % If it helps though, think of horizontal as the local x axis,
        % vertical as the local y axis, and normal() as the local z axis.  
        
        % Both properties are stored as matrices of size [1,3] representing
        % the unit vectors.  
        horizontal
        vertical
    end
    
    methods
        function obj = OrthogonalAxes(horizontal, vertical)
            if(nargin > 0)
                if(~isequal(size(horizontal), [1,3]))
                    error('Argument horizontal must have size [1,3].');
                end

                if(~isequal(size(vertical), [1,3]))
                    error('Argument vertical must have size [1,3].');
                end

                if(dot(horizontal, vertical) / ...
                        (norm(horizontal) * norm(vertical)) >= ...
                        OrthogonalAxes.PARALLEL_TOLERANCE)
                    error('The horizontal and vertical axes should be orthogonal to each other.');
                end

                % normalize the axes and set the property values
                obj.horizontal = horizontal ./ norm(horizontal);
                obj.vertical = vertical ./ norm(vertical);
            end % if(nargin > 0)
        end % function OrthogonalAxes
        
        vector = normal(obj)
    end
    
end

