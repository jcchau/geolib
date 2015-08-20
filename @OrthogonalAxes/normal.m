function vector = normal(obj)
% NORMAL Calculates the normal vector (the local z axis)
%   VECTOR is the normal vector, provided as a 1x3 row vector.

vector = cross(obj.horizontal, obj.vertical);

end

