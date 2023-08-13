function [maxCl] = getMaxCl(polarFile)
    % Returns the maxCl for the given polar file
    %   Use this function in console
    polar = readtable(polarFile, "Delimiter", ",");
    maxCl = max([polar.CL]);
end