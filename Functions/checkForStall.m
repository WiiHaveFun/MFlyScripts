function [stallIndex] = checkForStall(sf, numCases, surface, ClMax)
    % checkForStall Checks for stall on a surface based on a max Cl
    
    stallIndex = [];
    
    for i = 1:numCases
        stripForces = sf{i}(surface).strip;
        stripForces = cell2mat(stripForces);
    
        if (any([stripForces.cl] > ClMax))
            stallIndex = [stallIndex, i];
            disp(strcat("case ", string(i), " is stalled."));
        end
    end
end