function [x,t] = getThickness(file_path, n_points)
    % GETTHICKNESS outputs the thickness of an airfoil
    %   
    %   file_path = file path to an airfoil .dat file
    %   n_points = the number of points to return
    %
    % Written by: Michael Chen, miclchen@umich.edu

    points = readmatrix(file_path);
    
    [~, idx] = min(abs(points(:, 1)));
    
    top = points(1:idx, :);
    bottom = points(idx:end, :);
    
    x = linspace(min(points(:, 1)), max(points(:, 1)), n_points);
    
    z_u = interp1(top(:, 1), top(:, 2), x);
    z_l = interp1(bottom(:, 1), bottom(:, 2), x);
    
    t = z_u - z_l;