% SPMA_RESAMPLE - Resample an EEG dataset. Based on EEGLAB functions.
%
% Usage:
%     >> [EEG] = SPMA_resample(EEG)
%     >> [EEG] = SPMA_resample(EEG, 'key', val) 
%     >> [EEG] = SPMA_resample(EEG, key=val) 
%
% Inputs:
%    EEG        = [struct] EEG struct using EEGLAB structure system
%
% Optional inputs
%    Frequency  = [double] The new resampled frequency
%    Save       = [logical] Whether to save or not the resampled EEG.
% Outputs:
%    EEG = [struct] resampled EEG struct using EEGLAB structure system
%
% Authors: Alessandro Tonin, IRCCS San Camillo Hospital, 2024
% 
% See also: EEGLAB, POP_RESAMPLE

function [EEG] = SPMA_resample(EEG, opt)
    arguments (Input)
        EEG struct
        % Optional
        opt.Frequency double
        opt.EEGLAB (1,:) cell
        % Save options
        opt.Save logical
        opt.SaveName string
        opt.OutputFolder string
        % Log options
        opt.LogEnabled logical
        opt.LogLevel double {mustBeInteger,mustBeInRange(opt.LogLevel,0,6)}
        opt.LogToFile logical
        opt.LogFileDir string
        opt.LogFileName string
    end

    %% Constants
    module = "preprocessing";
    
    %% Parsing arguments
    config = SPMA_loadConfig(module, "resample", opt);

    %% Logger
    logConfig = SPMA_loadConfig(module, "logging", opt);
    log = SPMA_loggerSetUp(module, logConfig);
    
    %% Resampling
    log.info("Resampling")

    fs_old = EEG.srate;
    log.info(sprintf("Old sampling rate: %.1f", fs_old))

    EEG = pop_resample( EEG, config.Frequency, config.EEGLAB{:});
    log.info(sprintf("New sampling rate: %.1f", config.Frequency))

    %% Save
    if config.Save
        logParams = unpackStruct(logConfig);
        SPMA_saveData(EEG, "Name", config.SaveName, "Folder", module, "OutputFolder", config.OutputFolder, logParams{:});
    end

end

