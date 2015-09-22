function polygon = getPolygon(obj, row, column)
% GETPOLYGON Returns the polygon for the specified element in the array.
%
% POLYGON = getPolygon(OBJ, ROW, COLUMN)
%
% OBJ is the RectangularArray object.
% ROW and COLUMN are the MATLAB-matrix-style indices for the
%   RectangularArray element specified.  ROW is an integer value from 1 to
%   OBJ.nrows, where ROW 1 is the row with the largest coordinate value in
%   the OBJ.plane_axes.vertical direction.  COLUMN is an integer value from
%   1 to OBJ.ncols, where COLUMN 1 is the column with the minimum
%   coordinate value in the OBJ.plane_axes.horizontal direction.
% POLYGON is the polygon of the element at (IX,IY) in the array.

if(column<1 || row<1 || column>obj.ncols || row>obj.nrows)
    error('RectangularArray:IndexOutsideArray', ...
        'The provided indices are outside of the rectangular array.');
end

% calculate where the template polygon goes wrt the array's coordinate
% system.
element_anchor_x = (column-1 - obj.ncols/2) * obj.element_width;
element_anchor_y = (obj.nrows/2 - row) * obj.element_height;

% align the origin of the template with the the anchor point determined
template = obj.polygon_template.toMatrix();

% shift the template to the anchor location in the array's coordinate
% plane.
template(:,1) = template(:,1) + element_anchor_x;
template(:,2) = template(:,2) + element_anchor_y;
% Note: template may also have a z component.

% finally, convert from the array's local coordinate system to the global
% 3D coordinate system.

array_basis = [ obj.plane_axes.horizontal; ...
    obj.plane_axes.vertical; ...
    obj.plane_axes.normal() ];

polygon_matrix = template * array_basis + ...
    repmat(obj.centerpoint, size(template, 1), 1);

polygon = Polygon(polygon_matrix);

end
