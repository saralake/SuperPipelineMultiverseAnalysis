function [mdtable] = struct2mdtable(s, levels)
    arguments
        s struct
        levels (:,1) string
    end
    
    numLevels = length(levels);

    header = "";
    headerLine = "";
    for ii = 1:numLevels
        header = sprintf("%s | %s", header, levels(ii));
        headerLine = sprintf("%s | ---", headerLine);
    end
    header = sprintf("%s |", header);
    headerLine = sprintf("%s |", headerLine);
    mdtable = sprintf("%s\n%s\n", header, headerLine);


end

