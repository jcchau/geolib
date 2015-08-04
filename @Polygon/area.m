function a = area(obj)
% AREA returns the area of the Polygon.

[x, y] = obj.to2D();

a = polyarea(x, y);

end

