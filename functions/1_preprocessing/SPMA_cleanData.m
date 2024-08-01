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
% See also: EEGLAB, POP_CLEAN_RAWDATA

function [EEG] = SPMA_cleanData(EEG, opt)
    arguments (Input)
        EEG struct
        opt.Severity string {mustBeMember(opt.Severity, ["loose", "strict"])}
    end
    
    %% Parsing arguments
    config = SPMA_loadConfig("preprocessing", "cleanData", opt);

    %% Logger
    log = SPMA_loggerSetUp("preprocessing");
    
    %% Cleaning data
    log.info(sprintf("Cleaning data with %s parameters", config.Type))

    switch config.Type
        case "loose"
            EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion',5,'ChannelCriterion',0.8,'LineNoiseCriterion',4,'Highpass','off','BurstCriterion','off','WindowCriterion',0.25,'BurstRejection','off','Distance','Euclidian','WindowCriterionTolerances',[-Inf 50] );
        case "strict"
            EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion',5,'ChannelCriterion',0.8,'LineNoiseCriterion',4,'Highpass','off','BurstCriterion',20,'WindowCriterion',0.25,'BurstRejection','on','Distance','Euclidian','WindowCriterionTolerances',[-Inf 7] );
        otherwise
            error("Available types are only 'loose' and 'strict'. %s not available.", config.Type)
    end

    %% Save
    if config.Save
        SPMA_saveData(EEG,config.saveName)
    end

end

