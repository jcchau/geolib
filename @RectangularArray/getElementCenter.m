function center = getElementCenter(obj, row, column)
% getElementCenter returns the center point of the specified element of the
%   RectangularArray.
%
%   CENTER = getElementCenter(OBJ, ROW, COLUMN)
%
%   OBJ is the RectangularArray object.
%   ROW and COLUMN are the row (counting from 1 at the top) and column
%       (counting from 1 at the left) of the specified element.
%       ROW and COLUMN must both be column vectors of the same size.  
%   CENTER is the 3D center-point of the specified element.  
%
%   Note that getElementCenter does not consider the pixel_template when
%   determining the center of the element.

if(row<1 || column<1 || row>obj.nrows || column>obj.ncols)
    error('RectangularArray:IndexOutsideArray', ...
        'The provided indices are outside of the rectangular array.');
end

nelements = size(row, 1);
if(~isequal(size(row), [nelements,1]) || ...
        ~isequal(size(column), [nelements,1]))
    error('RectangularArray:BadIndexSize', ...
        'ROW and COLUMN must both be column vectors of the same size.');
end

% The coordinate of the center on the RectangularArray's plance_axes.
center_horiz = (column - (0.5 + obj.ncols/2)) .* obj.element_width;
center_vert = (obj.nrows/2 + 0.5 - row) .* obj.element_height;

% convert to the global 3D coordinate system

array_basis = [ obj.plane_axes.horizontal; ...
    obj.plane_axes.vertical];

center = [center_horiz, center_vert] * array_basis + ...
    repmat(obj.centerpoint, nelements, 1);

end

