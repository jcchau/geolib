function [a, b, origin, axisA, axisB] = to2D(obj)
% TO2D Converts the flat polygon in 3D space to an equivalent 2D polygon.
%
%   [A, B, ORIGIN, AXISA, AXISB] = to2D(OBJ)
%
%   OBJ is the Polygon object.
%   A is a column matrix of the vertices coordinates along the AXISA axis.
%   B is a column matrix of the vertices coordinates along the AXISB axis.
%   ORIGIN is the origin of the new 2D coordinate system in the original 3D
%       space.  This is chosen as the first vertex of the polygon.
%   AXISA is a unit vector as a row matrix, representing the A-axis in the
%       original 3D space.  
%   AXISB is a unit vector as a row matrix representing the B-axis in the
%       original 3D space.  
%
%   Both AXISA and AXISB are orthonormal and perpendicular to the plane's
%       normal vector.  

vertices = obj.toMatrix();

[plane, axisA, axisB] = obj.getPlane();

origin = plane.point;

% Convert vertices to be in terms of the new origin
vertices = vertices - repmat(origin, size(vertices, 1), 1);

% Get coordinates along axisA and axisB (which are already normalized).
% Equivalent to taking the dot product of each row of matrix vertices
% against axisA or axisB.
a = vertices * axisA';
b = vertices * axisB';

end

