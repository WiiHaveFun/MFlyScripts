function [rc, st, sf] = extractData(length, path)
    %ExtractData Parses the stability derivative and strip force files in a
    %give folder

    for i = 1:length
        rc{i} = parseRunCaseHeader(strcat(path, "/ST/data", string(i), ".txt"));
        st{i} = parseST(strcat(path, "/ST/data", string(i), ".txt"));
        sf{i} = parseSF(strcat(path, "/SF/data", string(i), ".txt"));
    end
end