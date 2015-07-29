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
        
    end % methods(Test)
    
    methods(Static)
        function coords = genPolygonCoordMatrix()
            numvertices = randi([3,10]);
            coords = rand([numvertices, 3]);
        end % function genPolygonMatrix
    end
end

