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
        % Optional
        opt.Channels (1,:) string
        opt.EEGLAB (1,:) cell
        % Save options
        opt.Save logical
        opt.SaveName string
        opt.OutputFolder string
        % Log options
        opt.LogEnabled logical
        opt.LogLevel double {mustBeInteger,mustBeInRange(opt.LogLevel,0,6)}
        opt.LogFileDir string
        opt.LogFileName string
    end
    
    %% Constants
    module = "preprocessing";

    %% Parsing arguments
    config = SPMA_loadConfig(module, "selectChannels", opt);

    %% Logger
    logConfig = SPMA_loadConfig(module, "logging", opt);
    log = SPMA_loggerSetUp(module, logConfig);
    
    %% Removing channels
    log.info("Selecting channels")

    log.info(sprintf("Selected channels %s", config.Channels))

    EEG = pop_select(EEG, 'channel', cellstr(config.Channels), config.EEGLAB{:});

    %% Save
    if config.Save
        logParams = unpackStruct(logConfig);
        SPMA_saveData(EEG, "Name", config.SaveName, "Folder", module, "OutputFolder", config.OutputFolder, logParams{:});
    end

end

