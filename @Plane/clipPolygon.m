function [polyout, isvalid] = clipPolygon(obj, polyin)
% CLIPPOLYGON Returns a polygon clipped to only keep the parts that are on
% the side of the plane in the direction of the normal vector.  
%
%   [POLYOUT, ISVALID] = clipPolygon(OBJ, POLYIN)
%
%   POLYIN is a Polygon object.
%   POLYOUT is the clipped Polygon object.
%   ISVALID indicates whether POLYOUT is a valid Polygon; ISVALID is only
%       false if POLYIN is entirely on the wrong side of the plane.

% Adapted from Kerosene/aboveMinZ.m

vertices = polyin.toMatrix();

% determine which vertices are on the +normal side of the plane.
keepvertex = ((vertices * obj.normal) + obj.d()) >= 0;

if(~any(keepvertex))
    isvalid = false;
    polyout = Polygon(); % not a valid polygon
elseif(all(keepvertex))
    % shortcut for efficiency (assuming that relatively few polygons will
    % stradle the plane.
    isvalid = true;
    polyout = polyin;
else
    isvalid = true;
    
    % Preallocate worst-case-size space for the output polygon.
    polyout = zeros(floor(1.5*size(polyin,1)), 3);
    
    % a count of the number of vertices out
    num_vertices_out = 0;
    
    % start with the previous vertex being the last polyin vertex
    iprev = size(polyin,1);
    
    % go through each input vertex
    for ivertex = 1:size(polyin,1)
        if(xor(keepvertex(ivertex), ~keepvertex(iprev)))
            % The from iprev to ivertex crosses the plane.
            % Insert a vertex where the edge intersects the plane.
            num_vertices_out = num_vertices_out + 1;
            [polyout(num_vertices_out,:), ~, ~] = obj.intersectRay(...
                vertices(iprev,:), ... % the point
                vertices(ivertex,:) - vertices(iprev,:) ... % the direction
                );            
        end % if(xor(keepvertex(ivertex), ~keepvertex(iprev)))
        
        if(keepvertex(ivertex))
            num_vertices_out = num_vertices_out + 1;
            polyout(num_vertices_out,:) = vertices(ivertex,:);
        end % if(keepvertex(ivertex))
        
        % prepare for the next iteration of this loop
        iprev = ivertex;
    end % for ivertex
    
    % finally, trim polyout to remove any extra allocated space
    polyout = polyout(1:num_vertices_out, :);
    
end % if(~any(keepvertex))

end

