function [alpha, CL, CD, e] = readPolarFromFile(ftFile)
    % READPOLARFROMFILE takes the .ft file from running AVLDRAGPOLAR and
    % extracts the data from it
    %
    %   ftFile = path to the .ft file
    %
    %   Returns 4 arrays containing angles of attack and their associated
    %   lift and drag coefficients as well as efficiency
    %
    % Written by: Michael Chen, miclchen@umich.edu
    % Inspired by code written by: Kohei Harada, kharad@umich.edu

    %% Parse total force data
    fid = fopen(ftFile, 'r');
    file = textscan(fid, '%s', 'delimiter', '\n', 'whitespace', '');
    file = file{1};
    fileLen = length(file);

    %% Get alpha, CL, CD, and e from file
    alpha = [];
    CL = [];
    CD = [];
    e = [];
    
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
            elseif length(A) > 4 && strcmp(A{5}, 'e')
                e = [e; str2double(A{7})];
            end
        end
    end
    
    fclose(fid);