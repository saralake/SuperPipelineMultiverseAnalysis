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
%    LowCutoff   = [double] The low cutoff frequency
%    HighCutoff   = [double] The high cutoff frequency
%
% Outputs:
%    EEG = [struct] filtered EEG struct using EEGLAB structure system
%
% Authors: Alessandro Tonin, IRCCS San Camillo Hospital, 2024
% 
% See also: EEGLAB, POP_EEGFILTNEW

function [EEG] = SPMA_filter(EEG, opt)
    arguments (Input)
        EEG struct
        opt.Type string {mustBeMember(opt.Type, ["lowpass", "highpass", "bandpass", "bandstop"])}
        opt.LowCutoff double 
        opt.HighCutoff double
        opt.EEGLAB (1,:) cell
        opt.Save logical
        opt.SaveName string
    end

    %% Parsing arguments
    config = SPMA_loadConfig("preprocessing", "filter", opt);

    %% Logger
    log = SPMA_loggerSetUp("preprocessing");

    %% Filter
    log.info("Filtering")
    switch config.Type
        case "lowpass"
            locutoff = 0;
            hicutoff = config.HighCutoff;
            revfilt = 0;
            log.info(sprintf("Lowpass filter - %d Hz", hicutoff));
        case "highpass"
            hicutoff = 0;
            locutoff = config.LowCutoff;
            revfilt = 0;
            log.info(sprintf("Highpass filter %d Hz", locutoff));
        case "bandpass"
            hicutoff = config.HighCutoff;
            locutoff = config.LowCutoff;
            revfilt = 0;
            log.info(sprintf("Bandpass filter %d - %d Hz", locutoff, hicutoff));
        case "bandstop"
            hicutoff = config.HighCutoff;
            locutoff = config.LowCutoff;
            revfilt = 1;
            log.info(sprintf("Bandstop filter %d - %d Hz", locutoff, hicutoff));
        otherwise
            % This should never happen since there is the argument
            % validation
            error("ERROR: Type %s not allowed. Only allowed filters are: 'lowpass', 'highpass', 'bandpass', bandstop'", config.Type)
    end
    
    EEG = pop_eegfiltnew(EEG,'locutoff',locutoff,'hicutoff',hicutoff,'revfilt',revfilt, config.EEGLAB{:});

    %% Save
    if config.Save
        SPMA_saveData(EEG,config.saveName)
    end
end

