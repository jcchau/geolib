classdef RectangularArrayTest < matlab.unittest.TestCase
    % RECTANGULARARRAYTEST Unit test cases for class RectangularArray.
    
    properties
    end
    
    methods(Test)
        %% Constructor
        function testConstructorHappy(tc)
            centerpoint = RectangularArrayTest.randnum(1,3);
            
            % generate orthonormal axes
            axis_horizontal = RectangularArrayTest.randnum(1,3);
            axis_horizontal_normalized = ...
                axis_horizontal ./ norm(axis_horizontal);
            axis_vertical = RectangularArrayTest.randnum(1,3);
            axis_vertical = axis_vertical - ...
                axis_horizontal_normalized * dot(axis_vertical, ...
                axis_horizontal_normalized);
            
            element_width = rand()./rand();
            element_height = rand()./rand();
            
            nrows = randi(5);
            ncols = randi(5);
            
            polygon = [ 0, 0, 0; ...
                element_width, 0, 0; ...
                0, element_height, 0 ];
            
            RectangularArray( ...
                centerpoint, axis_horizontal, axis_vertical, ...
                element_width, element_height, nrows, ncols, ...
                polygon);
        end % function testConstructorHappy
        
        %% Property access methods
    end % methods(Test)
    
    methods(Static)
        function r = randnum(rows, columns)
            % randnum returns a random.
            % Unlike rand, which picks from [0,1), r may be positive,
            % negative, zero, and may exceed 1.
            r = (rand(rows, columns)-0.5) ./ rand(rows, columns);
        end % function randnum
    end % methods(Static)
    
end

