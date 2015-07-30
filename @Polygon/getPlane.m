function [point, normal] = getPlane(obj)
% getPlane returns the point and normal vector that describes the plane on
%   which the polygon lies.
%
%   [POINT, NORMAL] = getPlane(OBJ)
%
%   OBJ is the Polygon object.
%   POINT is a point on the polygon's plane.
%   NORMAL is the unit normal vector.

vertices = obj.toMatrix();

% The first point on the polygon is as good as any other point on the
% plane.
point = vertices(1,:);

% Find the vector from each vertex to the next via subtraction.
end_vertices = [vertices(2:end,:); vertices(1,:)];
edge_vectors = end_vertices - vertices;

% For each vertex, cross the edge vectors that connect to it to find the
% normal vector.
previous_edge = [edge_vectors(end,:); edge_vectors(1:end-1,:)];
next_edge = edge_vectors;

% In case we have a triangle (with 3 rows, specify that we want to perform
% the cross product one column (i.e., along dimension 2) at a time).  
all_normals = cross(previous_edge, next_edge, 2);

% Calculate the magnitude of each normal vector; assume the largest
% cross-product gives us the most precise normal vector.  If the
% cross-product is zero, then the edges are parallel.
magnitudes = sqrt(...
    all_normals(:,1).^2 + all_normals(:,2).^2 + all_normals(:,3).^2);
% In case the magnitudes are equal (which is always for triangles), only
% pick one.
chosen_normal = find(magnitudes==max(magnitudes),1);

if(magnitudes(chosen_normal) == 0)
    error('Error: Error: All edges of the polygon are parallel.')
end

% Normalize the chosen normal vector to unit length
normal = all_normals(chosen_normal,:) ./ magnitudes(chosen_normal);

end

