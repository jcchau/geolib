classdef PlaneTest < matlab.unittest.TestCase
    %PlaneTest Unit test class for class Plane.
    
    properties
    end
    
    methods(Test)
        %% Constructor tests
        function testConstructorHappy(tc)
            point = (rand(1,3)-0.5)./rand();
            normal = rand(1,3)-0.5;
            
            try
                Plane(point, normal);
            catch
                tc.fatalAssertFail();
            end
        end % function testConstructorHappy
        
        %% Property access method tests
        function testSetPointHappy(tc)
            point = (rand(1,3)-0.5)./rand();
            normal = rand(1,3)-0.5;
            plane = Plane(point, normal);
            
            newpoint = (rand(1,3)-0.5)./rand();
            plane.point = newpoint;
            tc.verifyTrue(isequal(plane.point, newpoint));
        end % function testSetPointHappy
        
        function testSetNormalHappy(tc)
            point = (rand(1,3)-0.5)./rand();
            normal = rand(1,3)-0.5;
            plane = Plane(point, normal);
            
            newnormal = rand(1,3)-0.5;
            plane.normal = newnormal;
            
            % normalize both newnormal for comparison;
            % plane.normal should already be normalized.
            newnormal = newnormal ./ norm(newnormal);
            
            % Although a normal vector pointing in the opposite (parallel)
            % direction would define the same plane, we assume that
            % Plane.set.normal method does NOT flip the normal vector.
            tc.verifyTrue(isequal(plane.normal, newnormal));
        end % function testSetNormalHappy
        
        function testPropertyNormalIsUnitVector(tc)
            point = (rand(1,3)-0.5)./rand();
            normal = (rand(1,3)-0.5)./rand();
            plane = Plane(point, normal);
            
            magnitude = norm(plane.normal);
            
            tc.verifyEqual(magnitude, 1, 'AbsTol', 1e-15);
        end % function testPropertyNormalIsUnitVector
        
        %% isEqual
        function testIsEqualIdentical(tc)
            point = (rand(1,3)-0.5)./rand();
            normal = rand(1,3)-0.5;
            
            planeA = Plane(point, normal);
            planeB = Plane(point, normal);
            
            tc.verifyTrue(planeA.isEqual(planeB));
        end % function testIsEqualIdentical
        
        function testIsEqualEquivalent(tc)
            point = (rand(1,3)-0.5)./rand();
            normal = rand(1,3)-0.5;
            planeA = Plane(point, normal);
            
            % Find another point (pointB) that's also on the plane.
            % This algorithm relies on normal being a unit vector.
            normal = normal ./ norm(normal);
            rand_point = (rand(1,3)-0.5)./rand();
            % project this rand_point onto the plane by subtracting any
            % displacement from the original point that is parallel to the
            % normal.
            displacement_parallel_to_normal = ...
                normal .* dot(rand_point - point, normal);
            pointB = rand_point - displacement_parallel_to_normal;
            
            % And find another vector that's parallel to the original
            % normal vector.
            random_scaling_factor = (rand()-0.5)./rand();
            equiv_normal = normal .* random_scaling_factor;
            
            planeB = Plane(pointB, equiv_normal);
            
            tc.verifyTrue(planeA.isEqual(planeB));
        end % function testIsEqualEquivalent
        
        function testIsEqualFalse(tc)
            pointA = (rand(1,3)-0.5)./rand();
            normalA = rand(1,3)-0.5;
            planeA = Plane(pointA, normalA);
            
            pointB = (rand(1,3)-0.5)./rand();
            normalB = rand(1,3)-0.5;
            planeB = Plane(pointB, normalB);
            
            tc.verifyFalse(planeA.isEqual(planeB));
        end % function testIsEqualFalse
        
        function testIsEqualDifferentNormal(tc)
            point = (rand(1,3)-0.5)./rand();
            normalA = rand(1,3)-0.5;
            normalB = rand(1,3)-0.5;
            
            planeA = Plane(point, normalA);
            planeB = Plane(point, normalB);
            
            tc.verifyFalse(planeA.isEqual(planeB));
        end % function testIsEqualDifferentNormal
        
        function testIsEqualDifferentPoint(tc)
            pointA = (rand(1,3)-0.5)./rand();
            pointB = (rand(1,3)-0.5)./rand();
            normal = rand(1,3)-0.5;
            
            planeA = Plane(pointA, normal);
            planeB = Plane(pointB, normal);
            
            tc.verifyFalse(planeA.isEqual(planeB));
        end % function testIsEqualDifferentPoint
        
        %% d
        function testD(tc)
            % testD verifies that the value returned by Plane.D is equal to
            % p for the Hessian normal form of a plane as described in
            % http://mathworld.wolfram.com/Plane.html. 
            
            point = (rand(1,3)-0.5)./rand();
            normal = rand(1,3)-0.5;
            plane = Plane(point, normal);
            
            test_p = plane.d();
            
            expected_p = -dot(point, normal./norm(normal));
            tc.verifyEqual(test_p, expected_p, 'AbsTol', 1e-15);
        end % function testD
        
        %% intersectRay
        function testIntersectRayFindsIntersections(tc)
            % testIntersectRayFindsIntersection picks nrays points on a
            % plane, generates nrays rays through that point, and checks
            % that intersectRay finds the intersections.  
            
            % want intersectRay to not throw errors if no rays are
            % provided.
            nrays = randi([0,5]);
            
            % generate orthonormal plane axes
            [axisA, axisB, plane_point] = PlaneTest.genPlaneAxes();
            plane = Plane(plane_point, cross(axisA, axisB));
            
            % pick the intersection points
            intersection = PlaneTest.genPlanePoints(...
                axisA, axisB, plane_point, nrays);
            
            % generate a starting point for the ray
            ray_start = (rand(nrays,3)-0.5) ./ rand(nrays,3);
            
            ray_direction = intersection - ray_start;
            % randomly scale ray_direction
            direction_scale_factor = rand(nrays,1) ./ rand(nrays,1);
            ray_direction = ray_direction .* ...
                repmat(direction_scale_factor, 1, 3);
            
            test_intersection = ...
                plane.intersectRay(ray_start, ray_direction);
            
            % verify that intersectRay returns nrays rows
            tc.verifyEqual(size(test_intersection), [nrays, 3]);
            
            % verify that each test_intersection is approximately equal to
            % each actual intersection.
            deviation = test_intersection - intersection;
            for index=1:nrays
                tc.verifyLessThan(norm(deviation(index,:)), 1e-8);
            end % for index=1:nrays
        end % function testIntersectRayFindsIntersections
        
        function testIntersectRaySomeDontIntersect(tc)
            % testIntersectRaySomeDontIntersect verifies that
            % Plane.intersectRay correctly determines which rays intersect
            % the plane.
            
            nrays = randi([0,10]);
            [axisA, axisB, plane_anchor] = PlaneTest.genPlaneAxes();
            intersection = PlaneTest.genPlanePoints(...
                axisA, axisB, plane_anchor, nrays);
            
            plane = Plane(plane_anchor, cross(axisA, axisB));
            
            % generate the starting points for the rays
            ray_start = (rand(nrays,3)-0.5) ./ rand(nrays,3);
            
            ray_direction = intersection - ray_start;
            
            % randomly pick some rays to point away from the plane (i.e.,
            % no intersection)
            flipped_away = rand(nrays,1) > 0.5;
            
            ray_direction(flipped_away,:) = -ray_direction(flipped_away,:);
            
            [test_intersections, test_does_intersect] = ...
                plane.intersectRay(ray_start, ray_direction);
            
            % verify that intersectRay returns nrays rows
            tc.verifyEqual(size(test_intersections), [nrays, 3]);
            tc.verifyEqual(size(test_does_intersect), [nrays, 1]);
            
            % Check that intersectRay detects that
            %   - all rays that aren't flipped to point away do intersect
            %   and that
            %   - all rays that are flipped to point away do not intersect.
            tc.verifyTrue(all(test_does_intersect == ~flipped_away));
            
            % also check to make sure that including rays that don't
            % intersect won't mess up the detection of the intersection
            % point for rays that do intersect.
            deviation = test_intersections(~flipped_away,1) - ...
                intersection(~flipped_away,1);
            for index = 1:size(deviation,1)
                tc.verifyLessThan(norm(deviation(index,:)), 1e-8);
            end
        end % function testIntersectRaySomeDontIntersect
        
        function testIntersectRaySomeParallel(tc)
            % testIntersectRaySomeParallel verifies that Plane.intersect
            % correctly identifies and handles parallel rays.
            
            nrays = randi([0,10]);
            [axisA, axisB, plane_anchor] = PlaneTest.genPlaneAxes();
            intersection = PlaneTest.genPlanePoints(...
                axisA, axisB, plane_anchor, nrays);
            
            plane = Plane(plane_anchor, cross(axisA, axisB));
            
            ray_start = (rand(nrays,3)-0.5) ./ rand(nrays,3);
            
            % generate a random direction parallel to the plane
            parallel_a = (rand(nrays,1) - 0.5) ./ ...
                rand(nrays,1);
            parallel_b = (rand(nrays,1) - 0.5) ./ ...
                rand(nrays,1);
            parallel_direction = ...
                repmat(parallel_a,1,3) .* repmat(axisA, nrays, 1) + ...
                repmat(parallel_b,1,3) .* repmat(axisB, nrays, 1);
            
            % randomly make about half of the rays parallel
            set_parallel = rand(nrays,1) > 0.5;
            
            % Ensure that ray_direction has 3 columns (even if nrays is 0).
            ray_direction = zeros(nrays,3);
            
            ray_direction(~set_parallel,:) = ...
                intersection(~set_parallel,:) - ray_start(~set_parallel,:);
            ray_direction(set_parallel,:) = ...
                parallel_direction(set_parallel,:);
            
            % use the method under test
            [test_intersection, ~, is_parallel] = ...
                plane.intersectRay(ray_start, ray_direction);
            
            % verify that the parallel rays were correctly detected
            tc.verifyTrue(isequal(is_parallel, set_parallel));
            
            % and check that the intersections of rays that aren't parallel
            % are still found.  
            deviation = test_intersection(~set_parallel) - ...
                intersection(~set_parallel);
            for index = 1:size(deviation,1)
                tc.verifyLessThan(norm(deviation(index,:)), 1e-8);
            end
        end % function testIntersectRaySomeParallel
        
    end % methods(Test)
    
    methods(Static)
        function [axisA, axisB, anchor_point] = genPlaneAxes()
            % genPlaneAxes generates a random pair of orthonormal axes.
            % generate orthonormal plane axes
            axisA = rand(1,3)-0.5;
            axisA = axisA ./ norm(axisA);
            axisB = rand(1,3)-0.5;
            axisB = axisB - axisA * dot(axisB, axisA);
            axisB = axisB ./ norm(axisB);
            
            % pick a point for the plane
            anchor_point = (rand(1,3)-0.5)./rand();
        end
        
        function points = ...
                genPlanePoints(axisA, axisB, anchor_point, npoints)
            % genPlanePoints generates random points on the plane defined
            % by axisA, axisB, and anchor_point.
            
            a = (rand(npoints,1) - 0.5) ./ rand(npoints,1);
            b = (rand(npoints,1) - 0.5) ./ rand(npoints,1);
            points = repmat(a,1,3) .* repmat(axisA, npoints, 1) + ...
                repmat(b,1,3) .* repmat(axisB, npoints, 1) + ...
                repmat(anchor_point, npoints, 1);
        end
    end
end

