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
            
            obj = RectangularArray( ...
                centerpoint, plane_axes, ...
                element_width, element_height, nrows, ncols, ...
                polygon);
            
            %% verify the properties
            tc.verifyEqual(obj.centerpoint, centerpoint);
            
            tc.verifyEqual(obj.plane_axes.horizontal, ...
                plane_axes.horizontal);
            tc.verifyEqual(obj.plane_axes.vertical, ...
                plane_axes.vertical);
            
            tc.verifyEqual(obj.element_width, element_width);
            tc.verifyEqual(obj.element_height, element_height);
            
            tc.verifyEqual(obj.nrows, nrows);
            tc.verifyEqual(obj.ncols, ncols);
            
            tc.verifyEqual(obj.polygon_template.toMatrix(), ...
                polygon.toMatrix());
        end % function testConstructorHappy
        
        function testConstructorDefaultPolygon(tc)
            [centerpoint, plane_axes, ...
                element_width, element_height, nrows, ncols] = ...
                RectangularArrayTest.genRandRectangularArrayParams();
            
            obj = RectangularArray( ...
                centerpoint, plane_axes, ...
                element_width, element_height, nrows, ncols);
            
            %% verify the properties
            tc.verifyEqual(obj.centerpoint, centerpoint);
            
            tc.verifyEqual(obj.plane_axes.horizontal, ...
                plane_axes.horizontal);
            tc.verifyEqual(obj.plane_axes.vertical, ...
                plane_axes.vertical);
            
            tc.verifyEqual(obj.element_width, element_width);
            tc.verifyEqual(obj.element_height, element_height);
            
            tc.verifyEqual(obj.nrows, nrows);
            tc.verifyEqual(obj.ncols, ncols);
            
            tc.verifyEqual(obj.polygon_template.toMatrix(), ...
                [0, 0, 0; ...
                0, element_height, 0; ...
                element_width, element_height, 0; ...
                element_width, 0, 0], ...
                'The default polygon_template is incorrect.');
        end % function testConstructorDefaultPolygon
        
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
                -107.5, 104, 1; ...
                -104.5, 104, 1; ...
                -104.5, 102, 1];
            
            poly11_test = ra.getPolygon(1,1).toMatrix();
            tc.verifyTrue(isequal(poly11_test, poly11_expected), ...
                'The returned polygon for ix=1, iy=1 does not match the expected polygon.');
            
            %% for ix=2, iy=3
            poly23_expected = [-104.5, 98, 1; ...
                -104.5, 100, 1; ...
                -101.5, 100, 1; ...
                -101.5, 98, 1];
            
            poly23_test = ra.getPolygon(3,2).toMatrix();
            tc.verifyTrue(isequal(poly23_test, poly23_expected), ...
                'The returned polygon for ix=2, iy=3 does not match the expected polygon.');
            
            %% for ix=5, iy=4
            poly54_expected = [-95.5, 96, 1; ...
                -95.5, 98, 1; ...
                -92.5, 98, 1; ...
                -92.5, 96, 1];
            
            poly54_test = ra.getPolygon(4,5).toMatrix();
            tc.verifyTrue(isequal(poly54_test, poly54_expected), ...
                'The returned polygon for ix=5, iy=5 does not match the expected polygon.');
            
        end % function testGetPolygonSimple
        
        %% getElementCenter
        
        function testGetElementCenterAgainstGetPolygon(tc)
            [centerpoint, plane_axes, ...
                element_width, element_height, nrows, ncols] = ...
                RectangularArrayTest.genRandRectangularArrayParams();
            
            ra = RectangularArray(centerpoint, plane_axes, ...
                element_width, element_height, nrows, ncols);
            
            for row = 1:nrows
                for col = 1:ncols
                    center_test = ra.getElementCenter(row, col);
                    
                    polygon = ra.getPolygon(row, col);
                    polygon_matrix = polygon.toMatrix();
                    center_polygon = mean(polygon_matrix, 1);
                    
                    magnitude_error = norm(center_test - center_polygon);
                    
                    tc.verifyLessThan(magnitude_error, 1e-10, ...
                        'The center calculated by getCenter is too far from the center of the polygon representing the same element.');
                end % for col
            end % for row
        end % function testGetElementCenterAgainstGetPolygon
        
        %% listIntersectingElements
        function testListIntersectingElementsIncludesAll(tc)
            % testListIntersectingElementsIncludesAll ensures that all of
            % the intersecting elements are listed.  

            [centerpoint, plane_axes, element_width, element_height, ...
                nrows, ncols] = ...
                RectangularArrayTest.genRandRectangularArrayParams();

            % To avoid failing when we miss an element that barely touches
            % the intersecting polygon since the omission may be due to a
            % rounding error.
            AREA_TOLERANCE = 1e-12 * element_width * element_height;
            
            ra = RectangularArray(centerpoint, plane_axes, ...
                element_width, element_height, nrows, ncols);

            % A counter of the number of intersecting elements checked.
            % Occasionally the random intersecting_poly may be generated
            % such that it doesn't intersect any elements of the array.  
            num_intersecting_elements = 0;
            
            % a counter of the number of trials ran so far (due to no
            % intersecting elements)
            num_trials = 0;
            
            % keep testing until we check at least one intersecting element
            while(num_intersecting_elements == 0)

                % ensure that we don't loop forever
                tc.assertLessThan(num_trials, 1000, ...
                    'Something''s wrong; none of our random polygons intersect the array elements.');
                
                %% create a polygon that intersects this array
                nvertices = randi([3,6]);
                chord_angle_proportions = rand(nvertices, 1);
                chord_angle = 2*pi * cumsum(chord_angle_proportions) / ...
                    sum(chord_angle_proportions);

                % Set r so that it is uniformly distributed from 0 to the
                % longer of the array width or height.  
                % This gives us a good probability of having vertices both
                % inside and outside of the array.  
                r_to_vertex = rand(nvertices, 1) * ...
                    max(element_width*ncols, element_height*nrows);

                [poly_horiz, poly_verti] = pol2cart(chord_angle, r_to_vertex);

                % convert to clockwise polygon to suppress polybool warnings
                [poly_horiz, poly_verti] = poly2cw(poly_horiz, poly_verti);

                intersecting_poly = [poly_horiz, poly_verti] * ...
                    [plane_axes.horizontal; plane_axes.vertical] + ...
                    repmat(centerpoint, nvertices, 1);

                %% use method under test to get intersections
                test_element_list = ...
                    ra.listIntersectingElements(Polygon(intersecting_poly));

                %% check that all intersecting elements are listed
                % For each element in the array,
                %   - get the element's polygon
                %   - convert the element's polygon to the same 2D coordinates
                %   as in (poly_horiz, poly_verti)
                %   - intersect the element's polygon against the polygon
                %   (poly_horiz, poly_verti)
                %   - if the intersection's area is greater than 0, verify that
                %   the element is listed in test_element_list.

                for row = 1:nrows
                    for column = 1:ncols
                        element_poly = ra.getPolygon(row, column).toMatrix();
                        element_poly = element_poly - ...
                            repmat(centerpoint, size(element_poly, 1), 1);
                        ep_horiz = element_poly * plane_axes.horizontal';
                        ep_verti = element_poly * plane_axes.vertical';

                        [overlap_x, overlap_y] = polybool('intersection', ...
                            ep_horiz, ep_verti, poly_horiz, poly_verti);

                        if(polyarea(overlap_x, overlap_y) > AREA_TOLERANCE)
                            num_intersecting_elements = ...
                                num_intersecting_elements + 1;

                            tc.verifyTrue(any(ismember(...
                                test_element_list, [row, column], 'rows')), ...
                                'Intersecting element is missing from the list.');
                        end % if polyarea
                    end % for column
                end % for row

                % increment the num_trials counter
                num_trials = num_trials + 1;
            end % while(num_intersecting_elements == 0)
            
            tc.assertGreaterThanOrEqual(num_trials, 1, ...
                'We should have executed at least one trial.');
        end % function testListIntersectingElementsIncludesAll
        
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

