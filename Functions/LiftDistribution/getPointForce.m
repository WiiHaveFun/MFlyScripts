function [y_centroid, F] = getPointForce(y, L)
    % GETPOINTFORCE takes a lift distribution and calculates the location
    % where the point force acts (centroid) and the total force

    F = trapz(y, L);
    y_centroid = trapz(y, y.*L) / F;
end