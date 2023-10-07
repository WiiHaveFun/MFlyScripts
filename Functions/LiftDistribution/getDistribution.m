function [y, L] = getDistribution(filepath, surface, density, velocity, plotData)
    % GETDISTRIBUTION Parses the strip force files for a particular surface
    % and outputs two arrays which describe the lift distribution

    sf = parseSF(filepath);
    strips = sf(surface).strip;
    strips = [strips{:}];

    y = [strips.Yle];
    cl = [strips.cl];
    C = [strips.Chord];

    L = 0.5 * density * velocity^2 * cl .* C;

    if(plotData)
        plot(y, L, LineWidth=3);
    end
end