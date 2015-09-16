function indices = listIntersectingElements(obj, polygon)
% listIntersectingElements returns a list of 2-dimensional indices of the
% elements in the array that intersect the given polygon.  
%
%   Note that the intersection may be merely a single point; further
%   evaluations should be done to determine the extent to which each of the
%   listed elements intersect the polygon.  However, this function is
%   useful to limit the number of elements that need to be intersected with
%   each polygon (in case there are millions of elements in the array).  
%
%   INDICES = listIntersectingElements(OBJ, POLYGON)
%
%   OBJ is the RectangularArray object.
%   POLYGON is a Polygon object.  It is assumed to be on the same plane as
%       the RectangularArray OBJ.  To convert the 3D POLYGON coordinates
%       into indices, the POLYGON is projected onto this RectangularArray,
%       discarding the normal component of each point.  
%   INDICES is a NELEMENTS row by 2 column matrix, where each row holds the
%       (row, column) index of the RectangularArray element that intersects
%       the provided POLYGON.  
% 
%   In (row, column) indexing, (1,1) is the top-left element of the array;
%       this indexing is the same as the indexing MATLAB uses for 2D
%       matrices. 
%
%   For simplicity, indices may include the indices of some elements that
%   don't intersect the polygon.
%   TODO: Improve the specificity of this function later.

if(~isa(polygon, 'Polygon'))
    error('Polygon must be a Polygon object.');
end

% First get 2D coordinates
vertices3D = polygon.toMatrix();
vertices2D = obj.convertGlobalToArrayCoordinates(vertices3D);

% Then scale & shift so
% - that the interval between each integer value coordinate corresponds to
% a row or column of elements and
% - that the bottom left corner of the array corresponds to (0,0)
vertices2D(:,1) = vertices2D(:,1) ./ obj.element_width;
vertices2D(:,2) = vertices2D(:,2) ./ obj.element_height;

vertices2D(:,1) = vertices2D(:,1) + obj.ncols/2;
vertices2D(:,2) = vertices2D(:,2) + obj.nrows/2;

% For now, stick to Cartesian element indexing since it matches the vertex
% coordinates (i.e., the index equals the floor(coordinate)+1).  
% We can easily convert afterwards.

%% Clip the polygon against the border of the whole array
[vx, vy] = polybool('intersection', vertices2D(:,1), vertices2D(:,2), ...
    [0, 0, obj.ncols, obj.ncols], [0, obj.nrows, obj.nrows, 0]);
% polybool returns a closed polygon (in which the last vertex equals the
% first).

% We appear to have rounding errors from polybool which may allow vx or vy
% values slightly below 0 (which is outside of the RectangularArray). 
% Ensure that any vx or vy less than 0 is treated as exactly 0.
vx(vx<0) = 0;
vy(vy<0) = 0;

%% Determine the indices
% For now, return all of the indices that fit within the rectangular window
% that bounds the polygon.
x_min = floor(min(vx));
x_max = floor(max(vx));
y_min = floor(min(vy));
y_max = floor(max(vy));

% If vx==obj.ncols or vy==obj.nrows, that point is sitting on the rightmost
% or topmost boundary of the RectangularArray respectively.  Using the
% floor method like above, the boundary between index_x=ii and index_x=ii+1
% belongs to index_x=ii+1; the same for index_y.  As a result, points
% landing on the rightmost or topmost boundary would be assigned to
% elements outside of the RectangularArray.  Ensure that these boundaries
% are not assigned to elements outside of the RectangularArray (since that
% can cause problems when the element indices are used to refer to elements
% not in the RectangularArray).
x_max = min(x_max, obj.ncols-1);
y_max = min(y_max, obj.nrows-1);

indices_x_values = (x_min:x_max)' + 1;
indices_y_values = obj.nrows - (y_min:y_max)';

[index_x, index_y] = meshgrid(indices_x_values, indices_y_values);

% Here, we have some elements that don't intersect.
% This will cause more computation in the future, but okay for now.

% Convert from (index_x, index_y) to (row, column) indexing.
indices = [obj.nrows-index_y(:)+1, index_x(:)];

end
