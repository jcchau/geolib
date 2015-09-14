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
        
        %% transformPointsFromGlobal
        function testTransformPointsFromGlobal(tc)
            numpoints = randi([1, 5]);
            inpoints = rand(numpoints, 3) ./ ...
                repmat(rand(numpoints, 1), 1, 3);
            
            origin = rand(1,3) ./ rand();
            
            [axisA, axisB] = OrthogonalAxesTest.genAxesParams();
            obj = OrthogonalAxes(axisA, axisB);
            
            [h, v, n] = obj.transformPointsFromGlobal(origin, inpoints);
            
            % check that the returned variables have the correct size
            tc.verifyEqual(size(h), [numpoints, 1]);
            tc.verifyEqual(size(v), [numpoints, 1]);
            tc.verifyEqual(size(n), [numpoints, 1]);
            
            % convert outpoints back into global coordinates
            back_to_global = repmat(origin, numpoints, 1) + ...
                [h, v, n] * [obj.horizontal; obj.vertical; obj.normal()];
            
            % verify that the deviation is negligible
            difference = back_to_global - inpoints;
            
            for ii = 1:numpoints
                tc.verifyLessThan(norm(difference(ii, :)), 1e-11);
            end % for ii
            
        end % function testTransformPointsFromGlobal
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

