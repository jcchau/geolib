function points2D = convertGlobalToArrayCoordinates(obj, points3D)
% convertGlobalToArrayCoordinates converts 3D points in the global
% coordinate system to 2D points in the array's coordinate system.  
%
%   Note that this method projects each 3D point onto the array's plane,
%   discarding the component of the 3D point that is normal to the plane.  
%
%   POINTS2D = convertGlobalToArrayCoordinates(OBJ, POINTS3D)
%
%   OBJ is the RectangularArray object.
%   POINTS3D is a NPOINTS row by 3 column matrix where each row is the 3D
%       coordinates of the point.  
%   POINTS2D is the NPOINTS row by 2 column matrix where each row is the
%       corresponding 2D coordinate.  The first column is the coordinate
%       along the horizontal axis and the second column is the coordinate
%       along the vertical axis.  

[npoints, ncols] = size(points3D);

if(ncols ~=3)
    error('Argument points3D must have three columns.');
end

local3D = points3D - repmat(obj.centerpoint, npoints, 1);

points2D = local3D * [obj.axis_horizontal; obj.axis_vertical]';

end
