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
    arguments
        EEG struct
        opt.Frequency double
        opt.Save logical
    end
    
    %% Parsing arguments
    config_all = SPMA_loadConfig();
    config = mergeStruct(config_all.preprocessing.resample, opt);

    %% Logger
    log = SPMA_loggerSetUp("preprocessing");
    
    %% Resampling
    log.log("Resampling")

    fs_old = EEG.srate;
    log.info(sprintf("Old sampling rate: %.1f", fs_old))

    EEG = pop_resample( EEG, config.fs);
    log.info(sprintf("New sampling rate: %.1f", fs))

end

