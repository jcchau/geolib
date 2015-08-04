function a = area(obj)
% AREA returns the area of the Polygon.
%
% NOTE: this method uses the MATLAB method polyarea, which assumes that the
% polygon edges do not intersect.  

[x, y] = obj.to2D();

a = polyarea(x, y);

end

