classdef PolygonTest < matlab.unittest.TestCase
    %POLYGONTEST Unit tests for class Polygon.
    
    properties
    end
        
    methods(Test)
        %% Constructor tests
        function testConstructorHappy(testcase)
            numvertices = randi([3,10]);
            try
                Polygon(rand([numvertices, 1]), rand([numvertices, 1]), ...
                    rand([numvertices, 1]));
            catch
                testcase.fatalAssertFail();
            end
        end % function testConstructorHappy
        
        function testConstructorTwoVertices(testcase)
            try
                Polygon([0 1]', [0 1]', [0 2]');
                testcase.assertFail(...
                    'Failed to validate number for vertices > 3.');
            catch
            end
        end % function testConstructorTwoVertices
        
        function testConstructorMismatchParameterLengths(testcase)
            coords = PolygonTest.genPolygonCoordMatrix();
            
            try
                Polygon([coords(:,1); 1], coords(:,2), coords(:,3));
                testcase.assertFail('x too long.');
            catch
            end
            
            try
                Polygon(coords(:,1), [coords(:,2); 1], coords(:,3));
                testcase.assertFail('y too long.');
            catch
            end
            
            try
                Polygon(coords(:,1), coords(:,2), [coords(:,3); 1]);
                testcase.assertFail('z too long.');
            catch
            end
        end % function testConstructorMismatchParameterLengths
        
        %% toMatrix()
        function testToMatrixHappy(tc)
            c = PolygonTest.genPolygonCoordMatrix();
            p = Polygon(c(:,1), c(:,2), c(:,3));
            m = p.toMatrix();
            tc.assertEqual(m, c);
        end % function testToMatrixHappy
        
        %% getPlane()
        function testGetPlaneAndGenPolygonCoordMatrix(tc)            
            [coords, orig_plane] = ...
                PolygonTest.genPolygonCoordMatrix();
            pg = Polygon(coords(:,1), coords(:,2), coords(:,3));
            
            test_plane = pg.getPlane();
            
            tc.verifyTrue(orig_plane.isEqual(test_plane));
        end % function testGetPlaneAndGenPolygonCoordMatrix
        
        function testGetPlaneAgainstOld(tc)
            % testGetPlaneAgainstOld uses old method getPlane_old to check
            %   method getPlane.
            
            [coords, ~] = PolygonTest.genPolygonCoordMatrix();
            
            pg = Polygon(coords(:,1), coords(:,2), coords(:,3));
            
            test_plane = pg.getPlane();
            [ref_point, ref_normal] = pg.getPlane_old();
            ref_plane = Plane(ref_point, ref_normal);
            
            tc.verifyTrue(ref_plane.isEqual(test_plane));
        end % function testGetPlaneAgainstOld
        
        function testGetPlaneGeneratedAxes(tc)
            % Want cross(axisA,axisB) to equal normal.
            
            [coords, ~] = PolygonTest.genPolygonCoordMatrix();
            pg = Polygon(coords(:,1), coords(:,2), coords(:,3));

            [plane, axisA, axisB] = pg.getPlane();
            
            % check that each axis is normal
            tc.verifyEqual(norm(axisA), 1, 'AbsTol', 1e-15);
            tc.verifyEqual(norm(axisB), 1, 'AbsTol', 1e-15);
            
            % check that the axes are orthogonal to each other
            tc.verifyEqual(dot(axisA, axisB), 0, 'AbsTol', 1e-15);
            
            % and check that both axes are orthogonal to the normal.
            tc.verifyEqual(dot(axisA, plane.normal), 0, 'AbsTol', 1e-15);
            tc.verifyEqual(dot(axisB, plane.normal), 0, 'AbsTol', 1e-15);
            
            % and finally, check that cross(axisA, axisB) points in the
            % direction of normal.
            axisC = cross(axisA, axisB);
            deviation = axisC - plane.normal;
            tc.verifyLessThan(norm(deviation), 1e-15);
        end % function testGetPlaneGeneratedAxes
        
    end % methods(Test)
    
    methods(Static)
        function [coords, plane] = genPolygonCoordMatrix()
            % genPolygonCoordMatrix generates a random polygon.
            %
            %   [COORDS, PLANE] = genPolygonCoordMatrix()
            %
            %   COORDS is a NUMVERTICES x 3 matrix, where each of the
            %       NUMVERTICES rows represents a vertex and the columns
            %       represent the x, y, and z coordinates respectively.
            %       This should be identical to the format returned by
            %       Polygon.toMatrix().
            %
            %   PLANE define the plane on which the polygon lies, where
            %       PLANE is a Plane object.
            numvertices = randi([3,10]);
            
            % Divide by ramd() so center is not necessarily constrained to
            % have x,y, and z coordinates between +/-0.5.
            center = (rand(1,3) - 0.5)./rand();
            
            % Generate the axes of the plane on which the polygon lies
            axisA = rand(1,3) - 0.5;
            % normalize axisA
            axisA = axisA ./ norm(axisA);
            
            axisB = rand(1,3) - 0.5;
            % orthogonalize axisB
            axisB = axisB - dot(axisB, axisA).*axisA;
            % normalize axis B
            axisB = axisB ./ norm(axisB);
            
            %% Calculate the return values to describe the plane
            % calculate the normal vector since this will make tests for
            % getPlane() easier.
            normal = cross(axisA, axisB);
            plane = Plane(center, normal);
            
            %% generate a 2D shape
            
            % randomly divide 2*pi radians into numvertices parts
            angle_proportions = rand(numvertices,1);
            angle_proportions = angle_proportions ./ ...
                sum(angle_proportions) .* 2*pi;
            angle = cumsum(angle_proportions);
            
            % generate a random radius.
            % Divide by rand() so we're not constrained to radii < 1.
            radius = rand(numvertices,1) ./ rand();
            
            % convert this to the 2D shape in (a,b) coordinates.
            a = radius .* cos(angle);
            b = radius .* sin(angle);
            
            %% move to 3D space using parametric equation for plane
            % point = center + a.*axisA + b.*axisB;
            coords = repmat(center, numvertices, 1) + ...
                repmat(a,1,3) .* repmat(axisA, numvertices, 1) + ...
                repmat(b,1,3) .* repmat(axisB, numvertices, 1);
        end % function genPolygonMatrix
    end
end

