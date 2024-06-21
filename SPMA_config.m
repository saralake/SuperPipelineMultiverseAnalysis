% SPMA_CONFIG - The custom configurations used by all the
% functions. These configurations will overwrite the default ones.
%
% Usage:
%     >> [config] = SPMA_config;
%
% Outputs:
%    config = [struct] Nested structure with the custom configurations
%
% The current default configurations are:
% {
%   "general": {},
%   "preprocessing": {
%     "resampleFreq": 250
%   },
%   "headModel": {},
%   "sourceEstimation": {},
%   "connectivity": {},
%   "network": {}
% }
%
% Authors: Alessandro Tonin, IRCCS San Camillo Hospital, 2024
% 
% See also: SPMA_DEFAULTCONFIG


function config = SPMA_config()

config = struct();

%% GENERAL
general = struct();

% All the configurations

% Add to the main config struct
config.general = general;
%% PREPROCESSING
preproc = struct();

% All the configurations
preproc.resample.Frequency = 500;     % [Hz]  Sample frequency for resampling

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

