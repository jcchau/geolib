function polygon = getPolygon(obj, ix, iy)
% GETPOLYGON Returns the polygon for the specified element in the array.
%
% POLYGON = getPolygon(OBJ, IX, IY)
%
% OBJ is the RectangularArray object.
% IX and IY are the horizontal and vertical indices of the element in the
%   array.  
% POLYGON is the polygon of the element at (IX,IY) in the array.

% calculate where the template polygon goes wrt the array's coordinate
% system.
element_anchor_x = (ix-1 - obj.ncols/2) * obj.element_width;
element_anchor_y = (obj.nrows/2 - iy) * obj.element_height;

% align the origin of the template with the the anchor point determined
template = obj.polygon_template.toMatrix();

% shift the template to the anchor location in the array's coordinate
% plane.
template(:,1) = template(:,1) + element_anchor_x;
template(:,2) = template(:,2) + element_anchor_y;
% Note: template may also have a z component.

% finally, convert from the array's local coordinate system to the global
% 3D coordinate system.

array_basis = [ obj.axis_horizontal; obj.axis_vertical; obj.normal ];

polygon_matrix = template * array_basis + ...
    repmat(obj.centerpoint, size(template, 1), 1);

polygon = Polygon(polygon_matrix);

end
