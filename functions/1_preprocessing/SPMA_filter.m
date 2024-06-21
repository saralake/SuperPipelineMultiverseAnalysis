% SPMA_FILTER - Filter an EEG dataset. Based on EEGLAB functions.
%
% Usage:
%     >> [EEG] = SPMA_filter(EEG);
%     >> [EEG] = SPMA_filter(EEG, 'key', val);
%     >> [EEG] = SPMA_filter(EEG, key=val);
%
% Inputs:
%    EEG        = [struct] EEG struct using EEGLAB structure system
%
% Optional inputs:
%    Type       = [string] Type of the filter. Allowed values are:
%                   'bandpass', 'lowpass', 'highpass', 'bandstop'
%    LoCutoff   = [double] The low cutoff frequency
%    HiCutoff   = [double] The high cutoff frequency
%
% Outputs:
%    EEG = [struct] filtered EEG struct using EEGLAB structure system
%
% Authors: Alessandro Tonin, IRCCS San Camillo Hospital, 2024
% 
% See also: EEGLAB, POP_EEGFILTNEW

function [EEG] = SPMA_filter(EEG, opt)
    arguments
        EEG struct
        opt.Type string {mustBeMember(opt.Type, ["lowpass", "highpass", "bandpass", "bandstop"])}
        opt.LoCutoff double
        opt.HiCutoff double
    end

    %% Parsing arguments
    % DA CAMBIARE
    config = SPMA_defaultConfig();
    if isfield(opt, "Type")
        type = opt.Type;
    else
        type = config.preprocessing.filterType;
    end
    if isfield(opt, "LoCutoff")
        locutoff = opt.LoCutoff;
    else
        locutoff = config.preprocessing.filterLowCutoff;
    end
    if isfield(opt, "HiCutoff")
        hicutoff = opt.HiCutoff;
    else
        hicutoff = config.preprocessing.filterHighCutoff;
    end

    %% Filter
    switch type
        case "lowpass"
            locutoff = 0;
            revfilt = 0;
        case "highpass"
            hicutoff = 0;
            revfilt = 0;
        case "bandpass"
            revfilt = 0;
        case "bandstop"
            revfilt = 1;
        otherwise
            % This should never happen since there is the argument
            % validation
            error("ERROR: Type %s not allowed. Only allowed filters are: 'lowpass', 'highpass', 'bandpass', bandstop'", type)
    end
    EEG = pop_eegfiltnew(EEG, 'locutoff',locutoff,'hicutoff',hicutoff,'revfilt', revfilt);
end

