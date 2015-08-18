classdef RectangularArray
    % RECTANGULARARRAY A rectangular array in 3D space.
    %   Defines a rectangular array on a plane in 3D space.  Provides
    %   methods to map points and polygons on the plane to element indices
    %   in the array.  
    
    properties(Constant)
        PARALLEL_TOLERANCE = Plane.PARALLEL_TOLERANCE;
    end % properties(Constant)
    
    properties
        %% Define the plane on which the array lies.
        % All 1x3 row vectors
        
        % point in 3D space where the axes intersect
        centerpoint
        
        % define axis_horzontal and axis_vertical with SetAccess = private
        % in the next propertes section.  This is so we can ensure that
        % they are orthogonal to each other.
        
        %% Properties of the array
        
        % dimension of each array element along the horizontal axis
        element_width
        % dimension of each array element along the vertical axis
        element_height
        
        % number of rows and columns of elements
        nrows
        ncols
        
        %% And the element arrayed
        
        % A template of the polygon arrayed.  
        % The origin of this template would be aligned to the lower left
        % corner of each element's bounding box.  (i.e., origin in the
        % template corresponds to the point with the lowest valued
        % coordinates in both axis_horizontal and axis_vertical directions
        % in that element).  
        polygon_template
    end % properties
    
    properties(SetAccess = private)
        %% Set these using method setAxes
        % which validates that the axes are orthogonal
        % local x axis unit vector
        axis_horizontal
        % local y axis unit vector
        axis_vertical
    end % properties(SetAccess = private)
    
    methods
        %% Constructor
        function obj = RectangularArray( ...
                centerpoint, axis_horizontal, axis_vertical, ...
                element_width, element_height, nrows, ncols, ...
                polygon_template)
            % RectangularArray constructs a RectangularArray object.
            
            if(nargin>0)
                obj.centerpoint = centerpoint;
                obj.setAxes(axis_horizontal, axis_vertical);
                obj.element_width = element_width;
                obj.element_height = element_height;
                obj.nrows = nrows;
                obj.ncols = ncols;
                
                if(nargin >= 8)
                    % i.e., if polygon_template (the 8th argument) is
                    % provided.
                    obj.polygon_template = polygon_template;
                else
                    % by default, have the polygon fill the element
                    obj.polygon_template = Polygon( ...
                        [0, 0, 0; ...
                        element_width, 0, 0; ...
                        element_width, element_height, 0; ...
                        0, element_height, 0]);
                end % if(nargin >= 8)
            end % if(nargin>0)
            
        end % function RectangularArray  (constructor)
        
        %% Property access methods
        function obj = set.centerpoint(obj, newval)
            if(~isequal(size(newval), [1,3]))
                error('Property centerpoint must have size [1,3].');
            end
            
            obj.centerpoint = newval;
        end % function set.centerpoint
        
        function obj = set.axis_horizontal(obj, newval)
            if(~isequal(size(newval), [1,3]))
                error('Property axis_horizontal must have size [1,3].');
            end
            
            obj.axis_horizontal = newval ./ norm(newval);
        end % function set.axis_horizontal
        
        function obj = set.axis_vertical(obj, newval)
            if(~isequal(size(newval), [1,3]))
                error('Property axis_vertical must have size [1,3].');
            end
            
            obj.axis_vertical = newval ./ norm(newval);
        end % function set.axis_vertical
        
        function obj = set.element_width(obj, newval)
            if(newval <= 0)
                error('Property element_width must be positive.');
            end
            
            obj.element_width = newval;
        end % function set.element_width
        
        function obj = set.element_height(obj, newval)
            if(newval <= 0)
                error('Property element_height must be positive.');
            end
            
            obj.element_height = newval;
        end % function set.element_height
        
        function obj = set.nrows(obj, newval)
            if(newval < 1)
                error('The array must have at least one element.');
            end
            
            obj.nrows = newval;
        end % function set.nrows
        
        function obj = set.ncols(obj, newval)
            if(newval < 1)
                error('The array must have at least one element.');
            end
            
            obj.ncols = newval;
        end % function set.ncols
        
        function obj = set.polygon_template(obj, newval)
            if(~isa(newval, 'Polygon'))
                error('Property polygon_template must be a Polygon.');
            end
            
            obj.polygon_template = newval;
        end % function set.polygon_template
        
        %% Assignment methods
        function obj = setAxes(obj, axis_horizontal, axis_vertical)
            % setAxes updates the axis_horizontal and axis_vertical
            % properties.
            %   Ensures that the horizontal and vertical axes are
            %   perpendicular.  
            %
            %   OBJ = setAxes(OBJ, AXIS_HORIZONTAL, AXIS_VERTICAL)
            %
            %   AXIS_HORIZONTAL and AXIS_VERTICAL are the new values for
            %   the axis_horizontal and axis_vertical properties.  They
            %   should each be 3x1 row vectors.  
            if(dot(axis_horizontal, axis_vertical) / ...
                    (norm(axis_horizontal) * norm(axis_vertical)) >= ...
                    RectangularArray.PARALLEL_TOLERANCE)
                error('The horizontal and vertical axes should be orthogonal to each other.');
            end
            
            obj.axis_horizontal = axis_horizontal;
            obj.axis_vertical = axis_vertical;
        end % function setAxes
        
        %% Other methods
        
        vector = normal(obj)

        indices = listIntersectingElements(obj, polygon)
        
        polygon = getPolygon(obj, ix, iy)
    end % methods
    
end

