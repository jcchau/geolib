classdef Plane
    %PLANE Defines a plane in 3D space.
    %   A plane in 3D space as defined by a point on the plane and a normal
    %   vector.
    
    properties
        point
        
        % Property normal is always normalized to a unit vector by the set
        % property access method. 
        normal
    end
    
    properties(Constant)
        % The maximum acceptable magnitude for the cross product of two
        % parallel unit vectors.
        % Used by method isEqual to determine if two planes are identical.
        % Set to sin(1e-9) to set the threshold to vectors off by 1e-9
        % radians.
        PARALLEL_TOLERANCE = sin(1e-9); 
    end
    
    methods
        %% Constructors
        function obj = Plane(point, normal)
            % Plane constructs a Plane object.
            %
            % OBJ = Plane(POINT, NORMAL)
            %
            % POINT is a 3-column row vector representing the 3D coordinate
            %   of a point on the plane. 
            % NORMAL is a 3-column row vector representing the normal
            %   vector of the plane. 
            
            if(nargin>0)    % for the no input argument case
                obj.point = point;
                obj.normal = normal;
            end
        end % function Plane
        
        %% Property access methods
        function obj = set.point(obj, point)
            if(isequal(size(point), [1,3]))
                obj.point = point;
            else
                error('Property point must have size [1,3].');
            end
        end % function set.point
        
        function obj = set.normal(obj, normal)
            if(~isequal(size(normal), [1,3]))
                error('Property normal must have size [1,3].');
            end
            if(norm(normal) == 0)
                error('The normal vector must have a non-zero magnitude.');
            end
            
            % normalize the normal vector to unit length
            obj.normal = normal ./ norm(normal);
        end % function set.normal
        
        %% General methods
        function result = isEqual(obj, planeB)
            if(~isa(planeB, 'Plane'))
                error('Input planeB must be a Plane object.');
            end
            
            % verify that the normals are parallel
            if(norm(cross(obj.normal, planeB.normal)) >= ...
                    Plane.PARALLEL_TOLERANCE)
                % normal vectors aren't parallel
                result = false;
            else
                % normal vectors are parallel; check that the point
                % specified for planeB is also on this obj's plane.
                
                if(isequal(obj.point, planeB.point))
                    % They're the same point, so they must be on the same
                    % plane.
                    result = true;
                else
                    displacement = planeB.point - obj.point;
                    % normalize vector displacement so that the following
                    % dot product with the normal vector does not vary with
                    % the distance between the obj.point and planeB.point.
                    displacement = displacement ./ norm(displacement);
                    
                    if(abs(dot(displacement, obj.normal)) < ...
                            Plane.PARALLEL_TOLERANCE)
                        result = true;
                    else
                        result = false;
                    end
                end
            end
        end % function isEqual
        
        function p = d(obj)
            % d returns the value of d for the general plane equation:
            %   ax+by+cz+d=0
            % or
            %   dot(point, normal) + d = 0
            % where point is any point on the plane and normal is the
            % normal vector. 
            %
            % Since normal is stored as a unit vector in Plane, d is also
            % equal to p in the Hessian normal form of a plane as described
            % in http://mathworld.wolfram.com/HessianNormalForm.html.
            %
            % P = D(OBJ)
            
            p = -dot(obj.point, obj.normal);
        end % function d
        
        [intersection, ray_intersects, is_parallel] = ...
            intersectRay(obj, point, direction)
        
        [polyout, isvalid] = clipPolygon(obj, polyin)
    end
    
end

