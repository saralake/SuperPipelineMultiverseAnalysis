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
        customConfig (1,1) struct = struct()
        opt.Module (1,1) string {mustBeMember(opt.Module, ["all", "general", "preprocessing", "headmodel", "source", "sourceestimation", "connectivity", "network"])} = "all"
    end

    %Load default config
    config = SPMA_defaultConfig;

    % If no custom configuration, use the file defined in default config
    if isempty(fieldnames(customConfig))
        % If the file does not exist create a new one with default values
        customConfigPath = fullfile(config.general.customConfig.FileDir,config.general.customConfig.FileName);
        if ~exist(customConfigPath, "file")
            saveConfig(config, customConfigPath)
        end

        % Load the file
        customConfig = readConfig(customConfigPath);

    end

    % Merge default config with custom config
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

function saveConfig(c, pth)
    arguments
        c struct
        pth string
    end
    c_json = jsonencode(c, "PrettyPrint",true);
    fid = fopen(pth, "w");
    fwrite(fid, c_json);
    fclose(fid);
end

function c = readConfig(pth)
    arguments
        pth string
    end
    c_str = fileread(pth);
    c = jsondecode(c_str);
end
