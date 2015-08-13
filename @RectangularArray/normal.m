function vector = normal(obj)
% NORMAL Calculates tthe normal vector (the local z axis)
%   VECTOR is the normal vector, provided as a 1x3 row vector.

vector = cross(obj.axis_horizontal, obj.axis_vertical);

end

