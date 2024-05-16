function [x1, x2, c] = findUsefulChord(x, t, min_h, min_c, max_c, n_chords)
    % FINDUSEFULCHORD outputs the x-pos where the airfoil is thicker than
    % the required value
    %
    %   x = x positions of an airfoil
    %   t = thickness of an airfoil
    %   min_h = minimum height required
    %   min_c = minimum chord to search from
    %   max_c = maximum chord to search to
    %   n_chords = the number of chords to search through
    %
    % Written by: Michael Chen, miclchen@umich.edu

    c = linspace(min_c, max_c, n_chords)';

    x_scaled = repmat(x, n_chords, 1) .* c;
    t_scaled = repmat(t, n_chords, 1) .* c;

    x_useful = x_scaled;
    x_useful(isnan(t_scaled)) = NaN;
    x_useful(t_scaled < min_h) = NaN;

    x1 = min(x_useful, [], 2);
    x2 = max(x_useful, [], 2);
end