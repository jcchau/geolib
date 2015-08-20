classdef OrthogonalAxesTest < matlab.unittest.TestCase
    % ORTHOGONALAXESTEST Unit tests for OrthogonalAxes.
    
    properties
    end
    
    methods(Test)
        %% constructor
        function testConstructorHappy(tc)
            [axisA, axisB, axisA_normalized] = ...
                OrthogonalAxesTest.genAxesParams();
            
            obj = OrthogonalAxes(axisA, axisB);
            
            % Verify that the axes in obj are equal to the axisA and axisB
            % normalized.
            axisB_normalized = axisB ./ norm(axisB);
            
            deviationA = obj.horizontal - axisA_normalized;
            deviationB = obj.vertical - axisB_normalized;
            
            tc.verifyLessThan(norm(deviationA), 1e-10);
            tc.verifyLessThan(norm(deviationB), 1e-10);
        end % function testConstructorHappy
        
        function testConstructorNonOrthogonalAxes(tc)
            axisA = (rand(1,3)-0.5)./rand();
            axisB = (rand(1,3)-0.5)./rand();
            
            tc.verifyError(@()OrthogonalAxes(axisA, axisB), ...
                'OrthogonalAxes:NotOrthogonal', ...
                'OrthogonalAxes should generate an error for non-orthogonal axes.');
        end % function testConstructorNonOrthogonalAxes
        
        %% normal
        function testNormal(tc)
            [axisA, axisB] = OrthogonalAxesTest.genAxesParams();
            
            obj = OrthogonalAxes(axisA, axisB);
            
            % verify that it is the normalized cross product of
            % plane_axis.horizontal and plane_axis.vertical.
            normal = cross(obj.horizontal, obj.vertical);
            
            deviation = obj.normal() - normal;
            
            tc.verifyEqual(norm(deviation), 0, 'AbsTol', 1e-10);
        end % function testNormal
    end % methods(Test)
    
    methods(Static)
        function [axisA, axisB, axisA_normalized] = ...
                genAxesParams()
            axisA = (rand(1,3)-0.5)./rand();
            axisB = (rand(1,3)-0.5)./rand();
            
            axisA_normalized = axisA ./ norm(axisA);
            axisB = axisB - axisA_normalized .* ...
                dot(axisB, axisA_normalized);
        end % function genAxesParams
    end % methods
end

