% SPMA_REMOVECHANNELS - Remove a list of channels from an EEG dataset.
%
% Usage:
%     >> [EEG] = SPMA_removeChannels(EEG)
%     >> [EEG] = SPMA_removeChannels(EEG, 'key', val) 
%     >> [EEG] = SPMA_removeChannels(EEG, key=val) 
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

function [EEG] = SPMA_removeChannels(EEG, opt)
    arguments (Input)
        EEG struct
        opt.Channels (1,:) string
        opt.Save logical
        opt.SaveName string
    end
    
    %% Parsing arguments
    config_all = SPMA_loadConfig();
    config = mergeStruct(config_all.preprocessing.removeChannels, opt);

    %% Logger
    log = SPMA_loggerSetUp("preprocessing");
    
    %% Removing channels
    log.info("Removing channels")

    log.info(sprintf("Removed channels %s", config.Channels))

    EEG = pop_select(EEG, 'rmchannel', cellstr(config.Channels));

    %% Save
    if config.Save
        SPMA_saveData(EEG,config.saveName)
    end

end

