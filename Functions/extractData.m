function [rc, st, sf] = extractData(numCases, path)
    % ExtractData Parses the stability derivative and strip force files in a
    % given folder

    for i = 1:numCases
        rc{i} = parseRunCaseHeader(strcat(path, "/ST/data", string(i), ".txt"));
        st{i} = parseST(strcat(path, "/ST/data", string(i), ".txt"));
        sf{i} = parseSF(strcat(path, "/SF/data", string(i), ".txt"));
    end
end