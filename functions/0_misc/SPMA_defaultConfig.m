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
general.customConfig.FileDir = getCodeFolder();
general.customConfig.FileName = "SPMA_config.json"; % Name of the custom configuration file to overwrite the values in this file

% Logging
general.logging.Enabled = true;
general.logging.Level = 2;
general.logging.FileDir = getCodeFolder();
general.logging.FileName = "SPMA.log";

general.verbosity = 1; % 0: no verbose, 1: 

% Add to the main config struct
config.general = general;
%% PREPROCESSING
preproc = struct();

% All the configurations
preproc.resample.Frequency = 250;     % [Hz] Sample frequency for resampling
preproc.resample.EEGLAB = {};
preproc.resample.Save = false;        % 
preproc.resample.SaveName = "resample";        % 

preproc.filter.Type = "bandpass";     % Type of the filter
preproc.filter.LowCutoff = 0.5;       % [Hz] Low cutoff frequency for the filter
preproc.filter.HighCutoff = 48;       % [Hz] High cutoff frequency for the filter
preproc.filter.EEGLAB = {};
preproc.filter.Save = false;
preproc.filter.SaveName = "filter";

preproc.removeChannels.Channels = {};
preproc.removeChannels.EEGLAB = {};
preproc.removeChannels.Save = false;
preproc.removeChannels.SaveName = "removeChannels";

preproc.selectChannels.Channels = {};
preproc.selectChannels.EEGLAB = {};
preproc.selectChannels.Save = false;
preproc.selectChannels.SaveName = "selectChannels";

preproc.selectTime.AfterStart = 5;
preproc.selectTime.BeforeEnd = 5;
preproc.selectTime.EEGLAB = {};
preproc.selectTime.Save = false;
preproc.selectTime.SaveName = "selectTime";

preproc.cleanData.Severity = "loose";
preproc.cleanData.EEGLAB = {};
preproc.cleanData.Save = false;
preproc.cleanData.SaveName = "cleanData";

preproc.runica.Extended = 1;
preproc.runica.Interrupt = true;
preproc.runica.EEGLAB = {};
preproc.runica.SaveBefore = true;
preproc.runica.SaveNameBefore = "before_runica";
preproc.runica.Save = true;
preproc.runica.SaveName = "runica";


% Logging
preproc.logging.Enabled = true;
preproc.logging.Level = 2;
preproc.logging.FileDir = getCodeFolder();
preproc.logging.FileName = "SPMA.log";

% Add to the main config struct
config.preprocessing = preproc;
%% HEAD MODEL
headModel = struct();

% All the configurations

% Logging
headModel.logging.Enabled = true;
headModel.logging.Level = 2;
headModel.logging.FileDir = getCodeFolder();
headModel.logging.FileName = "SPMA.log";

% Add to the main config struct
config.headModel = headModel;
%% SOURCE ESTIMATION
source = struct();

% All the configurations

% Logging
source.logging.Enabled = true;
source.logging.Level = 2;
source.logging.FileDir = getCodeFolder();
source.logging.FileName = "SPMA.log";

% Add to the main config struct
config.sourceEstimation = source;
%% CONNECTIVITY
connectivity = struct();

% All the configurations

% Logging
connectivity.logging.Enabled = true;
connectivity.logging.Level = 2;
connectivity.logging.FileDir = getCodeFolder();
connectivity.logging.FileName = "SPMA.log";

% Add to the main config struct
config.connectivity = connectivity;

%% NETWORK ANALYSIS
network = struct();

% All the configurations

% Logging
network.logging.Enabled = true;
network.logging.Level = 2;
network.logging.FileDir = getCodeFolder();
network.logging.FileName = "SPMA.log";

% Add to the main config struct
config.network = network;

end

function mainFolder = getCodeFolder()
% retrieve the folder where lies the code
functionFolder = mfilename("fullpath");
mainFolderParent = extractBefore(functionFolder, "SuperPipelineMultiverseAnalysis");
mainFolder = fullfile(mainFolderParent, "SuperPipelineMultiverseAnalysis");

end
