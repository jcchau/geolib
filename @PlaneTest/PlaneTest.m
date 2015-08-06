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
    end % methods(Test)
    
end

