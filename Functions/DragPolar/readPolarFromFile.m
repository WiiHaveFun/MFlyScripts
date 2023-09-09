function [alpha, CL, CD] = readPolarFromFile(ftFile)
    % READPOLARFROMFILE takes the .ft file from running AVLDRAGPOLAR and
    % extracts the data from it
    %
    %   ftFile = path to the .ft file
    %
    %   Returns 3 arrays containing angles of attack and their associated
    %   lift and drag coefficients
    %
    % Written by: Michael Chen, miclchen@umich.edu
    % Inspired by code written by: Kohei Harada, kharad@umich.edu

    %% Parse total force data
    fid = fopen(ftFile, 'r');
    file = textscan(fid, '%s', 'delimiter', '\n', 'whitespace', '');
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