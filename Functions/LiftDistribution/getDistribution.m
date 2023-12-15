function [y, liftDistribution] = getDistribution(filepath, surface, density, velocity, plotData)
    % GETDISTRIBUTION Parses the strip force files for a particular surface
    % and outputs two arrays which describe the lift distribution

    sf = parseSF(filepath);
    strips = sf(surface).strip;
    strips = [strips{:}];

    y = [strips.Yle];
    cl = [strips.cl];
    C = [strips.Chord];

    liftDistribution = 0.5 * density * velocity^2 * cl .* C;


    if(plotData)
        plot(y, liftDistribution, LineWidth=3);
    end
end