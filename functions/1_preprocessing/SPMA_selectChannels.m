% SPMA_SELECTCHANNELS - Select a list of channels from an EEG dataset.
%
% Usage:
%     >> [EEG] = SPMA_selectChannels(EEG)
%     >> [EEG] = SPMA_selectChannels(EEG, 'key', val) 
%     >> [EEG] = SPMA_selectChannels(EEG, key=val) 
%
% Inputs:
%    EEG        = [struct] EEG struct using EEGLAB structure system
%
% Optional inputs
%    Channels  = [{str}] Cell array with channel names
%
% Outputs:
%    EEG = [struct] EEG struct using EEGLAB structure system
%
% Authors: Alessandro Tonin, IRCCS San Camillo Hospital, 2024
% 
% See also: EEGLAB, POP_SELECT

function [EEG] = SPMA_selectChannels(EEG, opt)
    arguments (Input)
        EEG struct
        opt.Channels (1,:) string
        opt.Save logical
        opt.SaveName string
    end
    
    %% Parsing arguments
    config = SPMA_loadConfig("preprocessing", "selectChannels", opt);

    %% Logger
    log = SPMA_loggerSetUp("preprocessing");
    
    %% Removing channels
    log.info("Selecting channels")

    log.info(sprintf("Selected channels %s", config.Channels))

    EEG = pop_select(EEG, 'channel', cellstr(config.Channels));

    %% Save
    if config.Save
        SPMA_saveData(EEG,config.saveName)
    end

end

