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
    

    % DA CAMBIARE
    config = SPMA_defaultConfig();
    if isfield(opt, "Frequency")
        fs = opt.Frequency;
    else
        fs = config.preprocessing.resample.Frequency;
    end
    
    %% Resampling
    fprintf(">>> Resampling \n")
    fs_old = EEG.srate;
    fprintf("Old sampling rate: %.1f \n", fs_old)
    EEG = pop_resample( EEG, fs);
    fprintf("New sampling rate: %.1f \n", fs)


end

