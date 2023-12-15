function [y_centroid, pointForce] = getPointForce(y, liftDistribution)
    % GETPOINTFORCE takes a lift distribution and calculates the location
    % where the equivalent point force acts (centroid) and the total force

    pointForce = trapz(y, liftDistribution);
    y_centroid = trapz(y, y.*liftDistribution) / pointForce;
end