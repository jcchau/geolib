function [h, v, n] = transformPointsFromGlobal(obj, origin, inpoints)
% transformPointsFromGlobal projects 3D points onto the OrthogonalAxes as
% 2D coordinates. 
%
% [H, V, N] = transformPointsFromGlobal(OBJ, ORIGIN, INPOINTS)
%
% OBJ is the OrthogonalAxes object.
% ORIGIN is a 3-element row vector representing global coordinates for
%   where the orthogonal axes intersect. 
% INPOINTS are the input points specified as a 3-column by NUMPOINTS-row
%   matrix, where each row represents a point. 
%
% H is a column vector with NUMPOINTS rows representing the coordinates
%   along the OBJ.horizontal direction.  
% V is a NUMPOINTS-element column vector representing the coordinates along
%   the OBJ.vertical direction.
% N is a NUMPOINTS-element column vector representing the coordinates along
%   the OBJ.normal direction.

if(size(inpoints,2) ~= 3)
    error('INPOINTS must be a 3-column matrix');
end

numpoints = size(inpoints,1);

% respecify the points about the origin
inpoints = inpoints - repmat(origin, numpoints, 1);

h = inpoints * obj.horizontal';
v = inpoints * obj.vertical';
n = inpoints * obj.normal()';

end

