% SPMA_LOGGERSETUP - Set up a logger for the pipeline
%
% Usage:
%     >> [log] = SPMA_loggerSetUp();
%
%
% Optional inputs:
%    Name
%    ShowDate
%    ShowTime
%    ShowFile
%    LogFile
%
% Outputs:
%    log = [logger] Logger object
%
% Authors: Alessandro Tonin, IRCCS San Camillo Hospital, 2024
% 
% See also: LOGGER

function log = SPMA_loggerSetUp(module, opt)
    arguments (Input)
        module (1,1) string {mustBeMember(module, ["general", "preprocessing", "headmodel", "source", "sourceestimation", "connectivity", "network"])}
        opt.Level double
        opt.FileDir string
        opt.FileName string
    end
    arguments (Output)
        log logger
    end

    %% Parsing arguments
    config_all = SPMA_loadConfig();
    switch module
        case "headmodel"
            module = headModel;
        case {"source", "sourceestimation"}
            module = sourceEstimation;
    end
    config = mergeStruct(config_all.(module).logging, opt);

    loggerName = sprintf("SPMA_%s", module);

    log = logger(loggerName);
    log.enabled = config.Enabled;
    log.default_level = config.Level;
    log.show_date = true;
    log.show_time = true;
    log.show_ms = true;
    log.show_logging_filename = true;
    log.log_to_command_window = true;
    log.log_to_file = true;
    log.log_directory = config.FileDir;
    log.log_filename = config.FileName;

end

