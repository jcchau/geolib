function [outX, outY, outZ] = rotateTo(zenithAngle, azimuth, tilt, ...
    inX, inY, inZ)
% [outX outY outZ] = rotateTo(zenithAngle, azimuth, tilt, inX, inY, inZ)
%
% Rotates the array of points (or polygon vertices) (inX, inY, inZ) about
% the origin to the orientation (zenithAngle, azimuth, tilt).  
%
% See "An Orientation Notation System for VLC" at
% <https://slerc.ecse.rpi.edu/download/attachments/2162886/VLCOrientationNotation.pdf>
% for more information about the orientation notation system used.  
%
% Angles are specified in radians.

% From Wikipedia
% <http://en.wikipedia.org/wiki/Euler_angles#Conversion_between_intrinsic_and_extrinsic_rotations>,
% "Any extrinsic rotation is equivalent to an intrinsic rotation by the
% same angles but with inverted order of elemental rotations, and
% vice-versa." 

% So, to stick with the global coordinate system, use extrinsic rotations:
%   - apply tilt first, by rotating the object about the Z axis;
%   - then apply the zenithAngle by rotating the object about the X axis;
%   - finally, apply the azimuth by rotating the object about the Z axis.

% Rotate tilt about the Z axis
[theta, r] = cart2pol(inX, inY);
theta = theta + tilt;
[inX, inY] = pol2cart(theta, r);

% Rotate zenithAngle about the X axis
[theta, r] = cart2pol(inY, inZ);
theta = theta + zenithAngle;
[inY, outZ] = pol2cart(theta, r);

% Finally, rotate azimuth about the Z axis
[theta, r] = cart2pol(inX, inY);
theta = theta + azimuth;
[outX, outY] = pol2cart(theta, r);

end