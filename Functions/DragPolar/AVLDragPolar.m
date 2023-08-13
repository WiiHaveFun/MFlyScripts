function [alpha, CL, CD] = AVLDragPolar(AVLDir, geoFile, outDir, AVLCommands, startAlpha, endAlpha, massFile)
    % AVLDRAGPOLAR runs AVL over a range of angle of attacks and saves the
    % output forces.
    %
    %   AVLDir = Absolute path to the directory with the AVL program
    %   geoFile = Absolute path to the geometry/.avl file
    %   outDir = Absolute path to the output directory
    %   AVLCommands = A string array where each item is a line to execute
    %   in AVL
    %   startAlpha = The starting angle of attack (deg)
    %   endAlpha = The end angle of attack (deg)
    %   massFile = an optional mass file
    %
    %   Returns 3 arrays containing angles of attack and their associated
    %   lift and drag coefficients
    %
    % Written by: Michael Chen, miclchen@umich.edu
    % Inspired by code written by: Kohei Harada, kharad@umich.edu

    %% Change directory to AVL folder
    cd(AVLDir);

    %% Define files
    AVLCommandsFile = strcat(outDir, "/AVLCommands.txt");
    ftFileName = "data.ft";
    ftFile = strcat(outDir, "/", ftFileName);

    % Delete files to prevent issues
    delete(AVLCommandsFile);
    delete(ftFile);

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

    % Set initial AOA and save data to .ft file
    fprintf(fid, 'a a %0.8f\n', startAlpha);
    fprintf(fid, 'x\n');
    fprintf(fid, 'w\n%s\n', ftFileName);

    % Iterate over alphas and save data to .ft file
    alphas = linspace(startAlpha, endAlpha, 20);
    for i = alphas(2:end)
        fprintf(fid, 'a a %0.8f\n', i);
        fprintf(fid, 'x\n');
        fprintf(fid, 'w\n\n');
    end

    % Exit OPER menu
    fprintf(fid, '\n');

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
    waitfor isfile(ftFileName)
    movefile(ftFileName, outDir);

    %% Parse total force data
    fid2 = fopen(ftFile, 'r');
    file = textscan(fid2, '%s', 'delimiter', '\n', 'whitespace', '');
    file = file{1};
    fileLen = length(file);

    %% Get alpha, CL, and CD from file
    alpha = [];
    CL = [];
    CD = [];
    
    % Iterate through all lines in file
    for i = 1:fileLen
        % Split the line
        A = strsplit(file{i}, ' ');
        if length(A) > 1
            % Check if line contains relevant data and store data
            if strcmp(A{2}, 'CLtot')
                CL = [CL; str2double(A{4})];
            elseif strcmp(A{2}, 'CDtot')
                CD = [CD; str2double(A{4})];
            elseif strcmp(A{2}, 'Alpha')
                alpha = [alpha; str2double(A{4})];
            end
        end
    end
    
    fclose(fid);
end