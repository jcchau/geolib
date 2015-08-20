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
        
        %% normal
        function testNormal(tc)
            [centerpoint, plane_axes, ...
                element_width, element_height, nrows, ncols] = ...
                RectangularArrayTest.genRandRectangularArrayParams();
            
            ra = RectangularArray( ...
                centerpoint, plane_axes, ...
                element_width, element_height, nrows, ncols);
            
            % verify that it is the normalized cross product of
            % plane_axis.horizontal and plane_axis.vertical.
            normal = cross(plane_axes.horizontal, plane_axes.vertical);
            normal = normal ./ norm(normal);
            
            deviation = ra.plane_axes.normal() - normal;
            
            tc.verifyEqual(norm(deviation), 0, 'AbsTol', 1e-10);
        end % function testNormal
        
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

