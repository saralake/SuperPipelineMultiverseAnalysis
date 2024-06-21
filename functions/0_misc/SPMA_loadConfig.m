% SPMA_LOADCONFIG - Load the configurations.
%
% Usage:
%     >> [config] = SPMA_loadConfig;
%     >> [config] = SPMA_loadConfig(customConfig);
%
% Inputs:
%   customConfig = [struct] The custom configuration. Default is loaded
%       from the file specified in default configuration.
%
% Optional inputs
%   Module  = [string] Load config of one specific module. Allowed modules
%               are: 'all', 'general', 'preprocessing', 'headmodel', 'source',
%               'connectivity', 'network'
%
% Outputs:
%    config = [struct] Nested structure with the default configurations
%
% Authors: Alessandro Tonin, IRCCS San Camillo Hospital, 2024
% 
% See also: SPMA_DEFAULTCONFIG


function config = SPMA_loadConfig(customConfig, opt)
    arguments
        customConfig struct = struct([])
        opt.Module string {mustBeMember(opt.Module, ["all", "general", "preprocessing", "headmodel", "source", "sourceestimation", "connectivity", "network"])} = "all"
    end

    config = SPMA_defaultConfig;

    % If no custom configuration, use the file defined in default config
    if isempty(customConfig)
        customConfig = feval(config.general.customConfigFileName);
    end

    config = mergeStruct(config, customConfig);

    % Extract only the desired module
    switch opt.Module
        case "general"
            config = config.general;
        case "preprocessing"
            config = config.preprocessing;
        case "headmodel"
            config = config.headModel;
        case {"source", "sourceestimation"}
            config = config.sourceEstimation;
        case "connectivity"
            config = config.connectivity;
        case "network"
            config = config.network;
    end

end

