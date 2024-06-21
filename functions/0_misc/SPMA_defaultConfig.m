% SPMA_DEFAULTCONFIG - The default configurations used by all the
% functions.
%
% Usage:
%     >> [config] = SPMA_defaultConfig;
%
% Outputs:
%    config = [struct] Nested structure with the default configurations
%
% The current configuration structure is:
% {
%   "general": {},
%   "preprocessing": {
%     "resampleFreq": 250
%     "filterType": 'bandpass'
%     "filterLowCutoff": 0.5
%     "filterHighCutoff": 48
%   },
%   "headModel": {},
%   "sourceEstimation": {},
%   "connectivity": {},
%   "network": {}
% }
%
% Authors: Alessandro Tonin, IRCCS San Camillo Hospital, 2024
% 
% See also: EEGLAB, POP_RESAMPLE


function config = SPMA_defaultConfig()

config = struct();

%% GENERAL
general = struct();

% All the configurations
general.customConfigFileName = "SPMA_config"; % Name of the custom configuration file to overwrite the values in this file
general.verbosity = 1; % 0: no verbose, 1: 

% Add to the main config struct
config.general = general;
%% PREPROCESSING
preproc = struct();

% All the configurations
preproc.resample.Frequency = 250;     % [Hz] Sample frequency for resampling
preproc.resample.Save = false;        % 
preproc.filter.Type = "bandpass";     % Type of the filter
preproc.filter.LowCutoff = 0.5;       % [Hz] Low cutoff frequency for the filter
preproc.filter.HighCutoff = 48;       % [Hz] High cutoff frequency for the filter
preproc.filter.Save = false;

preproc.ica.Save = true;

% Add to the main config struct
config.preprocessing = preproc;
%% HEAD MODEL
headModel = struct();

% All the configurations

% Add to the main config struct
config.headModel = headModel;
%% SOURCE ESTIMATION
source = struct();

% All the configurations

% Add to the main config struct
config.sourceEstimation = source;
%% CONNECTIVITY
connectivity = struct();

% All the configurations

% Add to the main config struct
config.connectivity = connectivity;

%% NETWORK ANALYSIS
network = struct();

% All the configurations

% Add to the main config struct
config.network = network;

end

