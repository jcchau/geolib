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
        function testGetPlaneAgainstOld(tc)
            
        end % function testGetPlaneAgainstOld
        
    end % methods(Test)
    
    methods(Static)
        function coords = genPolygonCoordMatrix()
            % genPolygonCoordMatrix generates a random polygon.
            %
            %   COORDS = genPolygonCoordMatrix()
            %
            %   COORDS is a NUMVERTICES x 3 matrix, where each of the
            %       NUMVERTICES rows represents a vertex and the columns
            %       represent the x, y, and z coordinates respectively.
            %       This should be identical to the format returned by
            %       Polygon.toMatrix().
            numvertices = randi([3,10]);
                        
            center = rand(1,3) - 0.5;
            
            % Generate the axes of the plane on which the polygon lies
            axisA = rand(1,3) - 0.5;
            % normalize axisA
            axisA = axisA ./ norm(axisA);
            
            axisB = rand(1,3) - 0.5;
            % orthogonalize axisB
            axisB = axisB - dot(axisB, axisA).*axisA;
            % normalize axis B
            axisB = axisB ./ norm(axisB);
            
            %% generate a 2D shape
            
            % randomly divide 2*pi radians into numvertices parts
            angle_proportions = rand(numvertices,1);
            angle_proportions = angle_proportions ./ ...
                sum(angle_proportions) .* 2*pi;
            angle = cumsum(angle_proportions);
            
            % generate a random radius
            radius = rand(numvertices,1);
            
            % convert this to the 2D shape in (a,b) coordinates.
            a = radius .* cos(angle);
            b = radius .* sin(angle);
            
            %% move to 3D space using parametric equation for plane
            % point = center + a.*axisA + b.*axisB;
            coords = repmat(center, numvertices, 1) + ...
                repmat(a,1,3) .* repmat(axisA, numvertices, 1) + ...
                repmat(b,1,3) .* repmat(axisB, numvertices, 1);
            
            %% enlarge the polygon
            % The polygon is currently < 1 in every dimension.
            % Enlarge by a random factor > 1.
            coords = coords ./ rand();
        end % function genPolygonMatrix
    end
end

