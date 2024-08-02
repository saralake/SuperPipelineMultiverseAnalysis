% BOOL2ONOFF - Converts boolean value to 'on' or 'off'
% 
% Usage:
%     >> [onoff] = bool2onoff(bool)
%
% Inputs:
%       bool    = [logical] boolean value to be converted in string
%
% Outputs:
%       onoff   = [string] 'on' or 'off'
%
% Authors: Alessandro Tonin, IRCCS San Camillo Hospital, 2024

function [onoff] = bool2onoff(bool)
    arguments (Input)
        bool logical
    end

    onoff = 'off';
    if bool
        onoff = 'on';
    end
end

