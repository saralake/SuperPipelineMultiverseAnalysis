% UNPACKSTRUCT - Unpack a struct in a cell array 
% Given a struct as input it returns a cell array as a sequence of key, val
% e.g. if s = struct(key1, val1, key2, val2, key3, val3) the output will be
% c = {key1, val1, key2, val2, key3, val3}.
% This function is useful to unpack a struct and use it as input for a
% function which requires key, val parametrs.
%
% Usage:
%   >> cellArray = unpackStruct(s)
% 
% Inputs:
%   s  = [struct] The structure to be unpacked
%
% Outputs:
%   c = [cell] A cell array in the form {key1, val1, key2, val2, ...}
%
% Authors: Alessandro Tonin, IRCCS San Camillo Hospital, 2024

function c1 = unpackStruct(s)
    arguments
        s (1,1) struct
    end
    fieldn = fieldnames(s);
    fieldv = struct2cell(s);
    nfield = length(fieldn);
    c1 = cell(2*nfield,1);
    c1(1:2:end) = fieldn;
    c1(2:2:end) = fieldv;
end
