function [stallAngle] = findStallAngle(AVLDir, geoFile, outDir, AVLCommands, density, mass, cref, cruiseVel, pp, surf, massFile)
    % FINDSTALLANGLE uses AVL to search for the stall angle of a plane
    %   The Reynolds number at each section on the given surface is
    %   computed to find the local max lift coefficient. This is compared
    %   to the local lift coefficient to check if the surface is stalled.
    %
    %   AVLDir = Absolute path to the directory with the AVL program
    %   geoFile = Absolute path to the geometry/.avl file
    %   outDir = Absolute path to the output directory
    %   AVLCommands = A string array where each item is a line to execute
    %   in AVL
    %   density = Air density
    %   cruiseVel = Cruise velocity
    %   pp = piecewise polynomial that relates max lift coefficient to
    %   Reynolds number
    %   surf = the index of the surface to check for stall on
    %   massFile = an optional mass file
    %
    %   Returns stall angle in degrees
    %
    % Written by: Michael Chen, miclchen@umich.edu
    % Inspired by code written by: Kohei Harada, kharad@umich.edu

    %% Initial bounds and tolerance
    alphaMin = 0;
    alphaMax = 20;
    epsilon = 1e-1;

    %% Search for the upper bound
    while ~AVLCheckForStall(alphaMax, AVLDir, geoFile, outDir, AVLCommands, density, mass, cref, cruiseVel, pp, surf, massFile)
        alphaMax = alphaMax * 2;
    end

    % Error is range of bounds
    error = alphaMax - alphaMin;

    %% Search for the stall angle using binary search
    while error > epsilon
        % Run AVL and check for stall
        midAlpha = (alphaMin + alphaMax) / 2;
           
        if AVLCheckForStall(midAlpha, AVLDir, geoFile, outDir, AVLCommands, density, mass, cref, cruiseVel, pp, surf, massFile);
            alphaMax = midAlpha;
        else
            alphaMin = midAlpha;
        end

        error = alphaMax - alphaMin;
    end

    stallAngle = midAlpha;
end