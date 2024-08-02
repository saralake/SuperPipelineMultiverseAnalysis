% SPMA_CLEANDATA - Automatic data cleaning removing bad channels.
%
% Usage:
%     >> [EEG] = SPMA_cleanData(EEG)
%     >> [EEG] = SPMA_cleanData(EEG, 'key', val) 
%     >> [EEG] = SPMA_cleanData(EEG, key=val) 
%
% Inputs:
%    EEG        = [struct] EEG struct using EEGLAB structure system
%
% Optional inputs
%    Severity  = [string] Severity of the paraemters to clean data.
%               Available values are "loose" or "strict".
%
% Outputs:
%    EEG = [struct] EEG struct using EEGLAB structure system
%
% Authors: Alessandro Tonin, IRCCS San Camillo Hospital, 2024
% 
% See also: EEGLAB, POP_SELECT

function [EEG] = SPMA_cleanData(EEG, opt)
    arguments (Input)
        EEG struct
        opt.Severity string {mustBeMember(opt.Severity, ["loose", "strict"])}
        opt.EEGLAB (1,:) cell
        opt.Save logical
        opt.SaveName string
    end
    
    %% Parsing arguments
    config = SPMA_loadConfig("preprocessing", "cleanData", opt);

    %% Logger
    log = SPMA_loggerSetUp("preprocessing");
    
    %% Cleaning data
    log.info(sprintf("Cleaning data with %s parameters", config.Type))

    switch config.Type
        case "loose"
            flatlineCrit = 5;
            channelCrit = 0.8;
            lineNoiseCrit = 4;
            highpass = 'off';
            burstCrit = 'off';
            windowCrit = 0.25;
            burstRejection = 'off';
            distance = 'Euclidian';
            windowCritTol = [-Inf 50]; 
            
        case "strict"
            flatlineCrit = 5;
            channelCrit = 0.8;
            lineNoiseCrit = 4;
            highpass = 'off';
            burstCrit = 20;
            windowCrit = 0.25;
            burstRejection = 'on';
            distance = 'Euclidian';
            windowCritTol = [-Inf 7]; 

        otherwise
            error("Available types are only 'loose' and 'strict'. %s not available.", config.Type)
    end

    EEG = pop_clean_rawdata(EEG, ...
        'FlatlineCriterion',flatlineCrit,...
        'ChannelCriterion',channelCrit, ...
        'LineNoiseCriterion',lineNoiseCrit, ...
        'Highpass',highpass, ...
        'BurstCriterion',burstCrit, ...
        'WindowCriterion',windowCrit, ...
        'BurstRejection',burstRejection, ...
        'Distance',distance, ...
        'WindowCriterionTolerances',windowCritTol, ...
        config.EEGLAB{:});

    %% Save
    if config.Save
        SPMA_saveData(EEG,config.saveName)
    end

end

