function [y_centroids, pointForces] = getPointForces(y, liftDistribution)
    % GETPOINTFORCES takes a lift distribution and splits it into pairs.
    % For each pair, the equivalent point force is calculated

    windowSize = 2;

    % Use the buffer function to create the smaller vectors
    yPairs = buffer(y, windowSize, windowSize-1, 'nodelay');
    distributionPairs = buffer(liftDistribution, windowSize, windowSize-1, 'nodelay');

    % Transpose the result matrix to get the desired orientation
    yPairs = yPairs';
    distributionPairs = distributionPairs';

    numPairs = size(distributionPairs, 1);

    y_centroids = zeros(1, numPairs);
    pointForces = zeros(1, numPairs);

    for i = 1:numPairs
        pointForces(i) = trapz(yPairs(i, :), distributionPairs(i, :));
        y_centroids(i) = trapz(yPairs(i, :), yPairs(i, :).*distributionPairs(i, :)) / pointForces(i);
    end
end