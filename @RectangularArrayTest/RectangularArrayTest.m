classdef RectangularArrayTest < matlab.unittest.TestCase
    % RECTANGULARARRAYTEST Unit test cases for class RectangularArray.
    
    properties
    end
    
    methods(Test)
        %% Constructor
        function testConstructorHappy(tc)
            [centerpoint, plane_axes, ...
                element_width, element_height, nrows, ncols] = ...
                RectangularArrayTest.genRandRectangularArrayParams();
            
            polygon = Polygon([ 0, 0, 0; ...
                element_width, 0, 0; ...
                0, element_height, 0 ]);
            
            RectangularArray( ...
                centerpoint, plane_axes, ...
                element_width, element_height, nrows, ncols, ...
                polygon);
        end % function testConstructorHappy
        
        %% Property access methods
        
        %% getPolygon
        function testGetPolygonSimple(tc)
            centerpoint = [-100 100 1];
            oa = OrthogonalAxes([1 0 0], [0 1 0]);
            element_width = 3;
            element_height = 2;
            nrows = 4;
            ncols = 5;
            
            ra = RectangularArray(centerpoint, oa, ...
                element_width, element_height, nrows, ncols);
            
            %% for ix=1, iy=1
            % poly11_expected calculated by pencil & paper
            poly11_expected = [-107.5, 102, 1; ...
                -104.5, 102, 1; ...
                -104.5, 104, 1; ...
                -107.5, 104, 1];
            
            poly11_test = ra.getPolygon(1,1).toMatrix();
            tc.verifyTrue(isequal(poly11_test, poly11_expected), ...
                'The returned polygon for ix=1, iy=1 does not match the expected polygon.');
            
            %% for ix=2, iy=3
            poly23_expected = [-104.5, 98, 1; ...
                -101.5, 98, 1; ...
                -101.5, 100, 1; ...
                -104.5, 100, 1];
            poly23_test = ra.getPolygon(2,3).toMatrix();
            tc.verifyTrue(isequal(poly23_test, poly23_expected), ...
                'The returned polygon for ix=2, iy=3 does not match the expected polygon.');
            
            %% for ix=5, iy=4
            poly54_expected = [-95.5, 96, 1; ...
                -92.5, 96, 1; ...
                -92.5, 98, 1; ...
                -95.5, 98, 1];
            poly54_test = ra.getPolygon(5,4).toMatrix();
            tc.verifyTrue(isequal(poly54_test, poly54_expected), ...
                'The returned polygon for ix=5, iy=5 does not match the expected polygon.');
            
        end % function testGetPolygonSimple
        
    end % methods(Test)
    
    methods(Static)
        function r = randnum(rows, columns)
            % randnum returns a random.
            % Unlike rand, which picks from [0,1), r may be positive,
            % negative, zero, and may exceed 1.
            r = (rand(rows, columns)-0.5) ./ rand(rows, columns);
        end % function randnum
        
        function [centerpoint, plane_axes, ...
                element_width, element_height, nrows, ncols] = ...
                genRandRectangularArrayParams()
            % genRandRectangularArrayParams returns a random set of
            % parameters that can be used to instantiate a RectangularArray
            % object.
            
            centerpoint = RectangularArrayTest.randnum(1,3);
            
            % generate orthonormal axes
            axis_horizontal = RectangularArrayTest.randnum(1,3);
            axis_horizontal_normalized = ...
                axis_horizontal ./ norm(axis_horizontal);
            axis_vertical = RectangularArrayTest.randnum(1,3);
            axis_vertical = axis_vertical - ...
                axis_horizontal_normalized * dot(axis_vertical, ...
                axis_horizontal_normalized);
            
            plane_axes = OrthogonalAxes(axis_horizontal, axis_vertical);
            
            element_width = rand()./rand();
            element_height = rand()./rand();
            
            nrows = randi(5);
            ncols = randi(5);
            
        end % function genRandRectangularArrayParams
    end % methods(Static)
    
end

