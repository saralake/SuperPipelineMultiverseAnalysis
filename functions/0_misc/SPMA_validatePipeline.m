% SPMA_VALIDATEPIPELINE - Validate a pipeline by checking that all the
% required fields are filled and that the overall structure is compatible
% with SPMA.
%
% Usage:
%     >> SPMA_validatePipeline(pipelineJSON)
%     >> SPMA_validatePipeline(pipelineJSON, 'key', 'val')
%
% Inputs:
%    pipelineJSON = [string] A json file with the pipeline
%
% Optional inputs
%    OutputFolder = [string] The output folder where to save the logs
%
% Authors: Alessandro Tonin, IRCCS San Camillo Hospital, 2024
% 
% See also: JSONDECODE

function SPMA_validatePipeline(pipelineJSON, opt)
    arguments (Input)
        pipelineJSON string {mustBeFile}
        % Save options
        opt.OutputFolder string
        % Log options
        opt.LogEnabled logical
        opt.LogLevel double {mustBeInteger,mustBeInRange(opt.LogLevel,0,6)}
        opt.LogToFile logical
        opt.LogFileDir string
        opt.LogFileName string
    end

    %% Parsing arguments
    config = SPMA_loadConfig("general", "save", opt);

    %% Logger
    logOptions = struct( ...
        "LogFileDir", config.OutputFolder);
    log = SPMA_loggerSetUp("general", logOptions);

    %% Load pipeline file
    pipeline_str = fileread(pipelineJSON);
    pipeline = jsondecode(pipeline_str);
    
    %% Validate pipeline

    STEPFIELDS = {
        'function';
        'name';
        'save';
        'log';
        'params'
    };

    % All the step fields must be structures or cell array of struct
    steps = fieldnames(pipeline);

    % Check each step
    for s = 1:length(steps)
        step = pipeline.(steps{s});

        l_multiverse = length(step);

        for n_universe = 1:l_multiverse
            if isstruct(step)
                universe = step(n_universe);
            elseif iscell(step)
                universe = step{n_universe};
            else
                errmsg = sprintf("Pipeline error - The step %s must be a struct or a cellarray (a multiverse)", steps(s));
                log.error(errmsg);
                error(errmsg);
            end

            universe_fields = fieldnames(universe);

            % Each step must contain only predefined fields
            wrongFields = setdiff(universe_fields, STEPFIELDS);
        
            if ~isempty(wrongFields)
                errmsg = sprintf("Pipeline error - In step %s the following fields are not allowed: %s. Only fields allowed: %s", ...
                    steps(s), strjoin(wrongFields, ', '), strjoin(STEPFIELDS, ', '));
                log.error(errmsg);
                error(errmsg);
            end

            % Each step must contain field "function"
            if ~ismember('function', universe_fields)
                errmsg = sprintf("Pipeline error - All universes of step %s MUST contain the field 'function'!", ...
                    steps(s));
                log.error(errmsg);
                error(errmsg);
            end
            
            % Not mandatory for a valide pipeline, but let's check if the
            % function is in the path
            if ~exist(universe.function)
                warnmsg = sprintf("Pipeline contains function %s, but the function is not in the path", universe.function);
                log.warning(warnmsg);
            end

            % If it is a multiverse also name is mandatory!
            if l_multiverse > 1 && ~ismember('function', universe_fields)
                errmsg = sprintf("Pipeline error - All universes of multiverse step %s MUST contain the field 'name'!", ...
                    steps(s));
                log.error(errmsg);
                error(errmsg);
            end

        end

    end

end

