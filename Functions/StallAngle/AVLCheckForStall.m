function [isStalled] = AVLCheckForStall(alpha, AVLDir, geoFile, outDir, AVLCommands, density, mass, cref, cruiseVel, pp, surf, massFile)
    % AVLCHECKFORSTALL runs AVL at a fixed angle of attack and checks if
    % the given surface is stalled.
    %
    %   alpha = angle of attack (deg)
    %   AVLDir = Absolute path to the directory with the AVL program
    %   geoFile = Absolute path to the geometry/.avl file
    %   outDir = Absolute path to the output directory
    %   AVLCommands = A string array where each item is a line to execute
    %   in AVL
    %   density = Air density (kg/m^3)
    %   cruiseVel = Cruise velocity (m/s)
    %   pp = piecewise polynomial that relates max lift coefficient to
    %   Reynolds number
    %   surf = the index of the surface to check for stall on
    %   massFile = an optional mass file
    %
    %   Returns stall angle in degrees
    %
    % Written by: Michael Chen, miclchen@umich.edu
    % Inspired by code written by: Kohei Harada, kharad@umich.edu

    %% Change directory to AVL folder
    cd(AVLDir);

    %% Define files
    AVLCommandsFile = strcat(outDir, "/AVLCommands.txt");
    fsFileName = strcat(string(alpha), ".fs");
    fsFile = strcat(outDir, "/", fsFileName);

    stFileName = strcat(string(alpha), ".st");
    stFile = strcat(outDir, "/", stFileName);

    % Delete files to prevent issues
    delete(AVLCommandsFile);
    delete(fsFile);
    delete(stFile);

    % Create output directory
    if(~isfolder(outDir))
        mkdir(outDir);
    end
    
    %% Create AVL command file
    fid = fopen(AVLCommandsFile, "w");

    % Load geometry file
    fprintf(fid, "load %s\n", geoFile);

    % Load AVL mass file if it exists
    if ~isnan(massFile)
        fprintf(fid, 'mass %s\n', massFile);
        fprintf(fid, 'mset 0\n');
    end

    % Enter OPER menu
    fprintf(fid, 'oper\n');

    % Apply custom commands (e.g. trimming)
    % Make sure to return to the oper menu
    for i=length(AVLCommands)
        fprintf(fid, AVLCommands(i));
    end

    % Set AOA and save data to .fs file
    fprintf(fid, 'a a %0.4f\n', alpha);
    fprintf(fid, 'x\n');
    fprintf(fid, 'fs\n%s\n', fsFileName);
    fprintf(fid, 'st\n%s\n', stFileName);

    % Exit OPER menu
    fprintf(fid, '\n\n\n');

    % Quit Program
    fprintf(fid, 'Quit\n');

    % Close File
    fclose(fid);

    %% Run AVL
    % For Windows
    [status, ~] = system(strcat("avl < ", AVLCommandsFile));
    % For MacOS
    if status ~= 0
        [~, ~] = system(strcat("./avl < ", AVLCommandsFile));
    end

    %% Wait for .fs file and move to output directory
    waitfor isfile(fsFileName)
    movefile(fsFileName, outDir);
    waitfor isfile(stFileName)
    movefile(stFileName, outDir);
    
    %% Parse strip forces data and check for stall
    SF = parseSF(fsFile);
    ST = parseRunCaseHeader(stFile);

    cruiseVel = (mass * 9.81 * 2 / density / ST.CLtot / cref) ^ 0.5;

    % Get local Reynolds numbers
    mu = 1.81e-5; % Dynamic viscocity
    re = density * cruiseVel * [cell2mat(SF(surf).strip).Chord] / mu;

    % Check if any strip has stalled compared to their local Reynolds
    % number
    % disp([cell2mat(SF(surf).strip).cl] > ppval(pp,re))
    if any([cell2mat(SF(surf).strip).cl] > ppval(pp,re))
    % if any(([cell2mat(SF(surf).strip).ccl] ./ 0.15610) > ppval(pp,re))
        isStalled = true;
    else
        isStalled = false;
    end
end