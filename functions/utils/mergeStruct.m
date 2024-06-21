% MERGESTRUCT - Merge two or more structures. 
% The first structure is the main one, all the others will be
% substructures. Only the fields of the main structure will be present in
% the final merged structure. The substructures can overwrite the value of
% fields of the main structure. If multiple substructures overwrite the
% same field, the last one is used.
%
% Usage:
%   >> structFinal = mergeStruct(mainStruct, subStruct1, subStruct2, ...)
% 
% Inputs:
%   mainStruct  = [struct] The main structure. The final structure will
%                   have the same fields
%   subStruct   = [struct] A substructure used to overwrite fields from the
%                   main structure
%
% Outputs:
%   structFinal = [struct] A structure with the same fields of the main
%                   structure, but the values can be updated.
%
% Authors: Alessandro Tonin, IRCCS San Camillo Hospital, 2024

function structFinal = mergeStruct(mainStruct,subStructs)
    arguments
        mainStruct struct
    end
    arguments (Repeating)
        subStructs struct
    end

    structFinal = mainStruct;
    mainFields = fieldnames(structFinal);

    n = numel(subStructs);

    for structNum = 1:n

        subStruct = subStructs{structNum};

        for fieldNum = 1:length(mainFields)
            field = mainFields{fieldNum};
            if isfield(subStruct, field)
                field_val = subStruct.(field);
                if isstruct(field_val)
                    field_val = mergeStruct(structFinal.(field), field_val);
                end
                structFinal.(field) = field_val;
            end
        end
    end

end

