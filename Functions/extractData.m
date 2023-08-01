function [rc, st, sf] = extractData(numCases, path, getST, getSF)
    % ExtractData Parses the stability derivative and strip force files in a
    % given folder

    rc = [];
    st = [];
    sf = [];

    for i = 1:numCases
        if getST
            rc{i} = parseRunCaseHeader(strcat(path, "/ST/data", string(i), ".txt"));
            st{i} = parseST(strcat(path, "/ST/data", string(i), ".txt"));
        end

        if getSF
            sf{i} = parseSF(strcat(path, "/SF/data", string(i), ".txt"));
        end
    end
end