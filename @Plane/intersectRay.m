function [intersection, ray_intersects, is_parallel] = ...
    intersectRay(obj, point, direction)
% INTERSECTRAY calculates the 3D point where a ray intersects a plane.
%
%   [INTERSECTION, RAY_INTERSECTS, IS_PARALLEL] = intersectRay(...
%           OBJ, POINT, DIRECTION)
%
%   OBJ is a Plane object.
%   POINT is the starting point of the ray.  POINT must have 3 columns (one
%       for each of the x, y, and z coordinates in that order) and may
%       either be a row vector, or (for multiple rays) a NRAYS by 3 matrix,
%       where NRAYS is the number of rays.  
%   DIRECTION is the direction of each ray (which starts at the point
%       specified in the same row in POINT) represented as a vector with
%       non-zero magnitude.  DIRECTION is a NRAYS by 3 matrix, where the
%       three columns represent the x, y, and z coordinates in that order.
%
%   To specify a ray defined by two points, where the second point is
%   POINT2, DIRECTION should be equal (POINT2 - POINT).
%
%   INTERSECTION is a NRAYS by 3 matrix, where each row is the 3D point
%       where the ray specified by the same row in POINT and DIRECTION
%       intersects the plane defined by OBJ.  
%
%   RAY_INTERSECTS indicates whether the ray actually intersects the plane.
%       RAY_INTERSECTS will be false
%           - if DIRECTION points away from the plane or
%           - if DIRECTION runs parallel to the plane (perpendicular to the
%           plane's normal) and POINT is not on the plane.
%       Otherwise, the ray intersects the plane and RAY_INTERSECTS is true.
%       The corresponding row in INTERSECTION should be considered invalid
%       if RAY_INTERSECTS is false.
%
%   IS_PARALLEL indicates whether the ray is parallel to the plane (within
%       the tolerance specified as Plane.PARALLEL_TOLERANCE.  

%% Input validation for point and direction
nrays = size(point, 1);

if(~isequal(size(point), [nrays 3]))
    error('POINT must be a NRAYS by 3 matrix.');
end

if(~isequal(size(direction), [nrays 3]))
    error('DIRECTION must be a NRAYS by 3 matrix.');
end

% The magnitude of the direction vector(s).
% Also used later to normalize the direction vectors. 
direction_magnitude = sum(direction.^2, 2);

% The calling function may accidentally have a direction vector with zero
% magnitude if it were calculating the direction vector with a second point
% (and that second point happens to be equal to the first).  
% TODO: find a more lenient way to handle this case.
if(any(direction_magnitude == 0))
    error('Each DIRECTION vector must have non-zero magnitude to indicate direction.');
end

%% Calculate the intersection point
% The intersection of the point and the plane satisfy:
%   intersection = t*direction + point  (for some positive t) and
%   dot(intersection, obj.normal) + obj.d = 0  (i.e., the general plane
%       equation)
t = -(point * obj.normal' + obj.d) ./ (direction * obj.normal');
intersection = repmat(t, 1, 3) .* direction + point;

% If the t that solves these two equations is negative, then the plane is
% behind the start of the ray and the ray will not hit the plane.  
ray_intersects = t>=0;

%% Detect whether DIRECTION is parallel to the plane

% for each ray, this is equal to the dot product of the normalized
% direction vector and the plane's normal.
normal_component = (direction * obj.normal') ./ direction_magnitude;

is_parallel = (normal_component < Plane.PARALLEL_TOLERANCE);

end
