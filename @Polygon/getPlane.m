function [point, normal] = getPlane(obj)
% getPlane returns the point and normal vector that describes the plane on
%   which the polygon lies.

vertices = obj.toMatrix();

% (arbitrarily) choose the first point as the point to return
point = vertices(1,:);

vector1 = vertices(2,:) - vertices(1,:);
vector2 = vertices(end,:) - vertices(1,:);

% calculate the normal as the cross product between the vectors formed by
% the edges that connect to the first vertex.
normal = cross(vector1, vector2);

%% Check in case the two edges are parallel
numvertices = size(vertices,1);
% start with the 2nd vertex since we already tried the first
vertex_index = 2;
while(dot(normal, normal) == 0 && vertex_index < numvertices)
    % The normal vector has zero magnitude: vector1 and vector2 are
    % parallel.
    % Try the edges around the remaining vertices;
    % The last iteration is for vertex_index == (numvertices-1) because
    %   - The code will be different to calculate the vector from the last
    %   vertex to the first vertex; and
    %   - If the edges around every other vertex are parallel, then the
    %   edges around the last vertex will also be parallel.  
    vector1 = vertices(vertex_index-1,:) - vertices(vertex_index,:);
    vector2 = vertices(vertex_index+1,:) - vertices(vertex_index,:);
    
    normal = cross(vector1, vector2);
end

if(dot(normal, normal) == 0)
    error('Error: All edges of the polygon are parallel.')
end

end