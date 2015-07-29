function vertices = toMatrix(obj)
% toMatrix returns the polygon as a matrix of coordinates.
%   Each row (first dimension) represent a vertex. 
%   The columns represent the x, y, and z coordinates (in that order).

vertices = [obj.x, obj.y, obj.z];

end