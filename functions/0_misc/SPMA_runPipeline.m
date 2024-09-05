% SPMA_RUNPIPELINE - Run a multiverse pipeline over a set of data.
%
% Usage:
%     >> SPMA_runPipeline(pipelineJSON, data)
%     >> SPMA_runPipeline(pipelineJSON, data, "OutputFolder", output)
%
% Inputs:
%    pipelineJSON = [string] A json file
%    data    = [struct] The name of the saved file (default: the name
%           of the calling function)
%    saveFolder  = [string] The folder where to save the file (default: the
%           name of the module of the calling function)
%
%
% Authors: Alessandro Tonin, IRCCS San Camillo Hospital, 2024
% 
% See also: SAVE, POP_SAVESET

function data = SPMA_runPipeline(pipelineJSON, data, opt)
    arguments (Input)
        pipelineJSON string {mustBeFile}
        data
        opt.OutputFolder string
    end

    %% Parsing arguments
    config = SPMA_loadConfig("general", "save", opt);

    %% Logger
    logOptions = struct( ...
        "LogFileDir", config.OutputFolder, ...
        "LogToFile", true);
    log = SPMA_loggerSetUp("general", logOptions);

    %% START
    log.info(">>> START MULTIVERSE ANALYSIS <<<")

    %% Load pipeline
    pipeline_str = fileread(pipelineJSON);
    pipeline = jsondecode(pipeline_str);
    % TODO: Check pipeline

    log.info(sprintf("Pipeline file: %s", pipelineJSON));
    log.info("\n"+jsonencode(pipeline, "PrettyPrint", true));

    logParams = unpackStruct(logOptions);
    SPMA_drawPipeline(pipeline, "OutputFolder", config.OutputFolder, logParams{:})

    % Save pipeline
    copyfile(pipelineJSON, config.OutputFolder)

    %% Starts the loop
    steps = fieldnames(pipeline);
    log.info(sprintf("There are %d steps", length(steps)))

    data = {data};

    for n_steps = 1:length(steps)
        step = pipeline.(steps{n_steps});
        log.info(sprintf("> Step: %d", n_steps))
        
        n_multiverse = length(step);
        log.info(sprintf("There are %d multiverses", n_multiverse))

        l_data = length(data);
        for n_data = 1:l_data
            current_data = data{n_data};
            for variation = 1:n_multiverse
                step_variation = step(variation);
                log.info(sprintf(">> Universe: %d", variation))
                
                % Run the step
                out = run_step(current_data, step_variation, config.OutputFolder);

                % Save the output in our data array
                idx = n_data + (variation-1)*l_data;
                data{idx} = out;

            end % variation
        end % n_data
    end % n_steps

    %% END
    log.info(">>> END MULTIVERSE ANALYSIS <<<")

end

function dataOut = run_step(dataIn, step, output)

    % Check if there are custom params
    if isfield(step, "params")
        params = step.params;
    else
        params = struct();
    end
    
    % Check if there is a custom name
    if isfield(step, "name")
        name = step.name;
    else
        name = step.function;
    end
    params.SaveName = name;
    
    % Check if must be saved
    if isfield(step, "save")
        params.Save = step.save;
    end

    % Check if there are custom log params
    if isfield(step, "log")
        params = catStruct(params, step.log);
        if ~isfield(step.log, "LogFileDir")
            params.LogFileDir = output;
        end
        if ~isfield(step.log, "LogToFile")
            params.LogToFile = true;
        end
    else
        params.LogFileDir = output;
        params.LogToFile = true;
    end
    
    % Update output folder
    params.OutputFolder = output;
    
    % Create function handle
    fun = str2func(step.function);
    
    % Convert params to a cell array
    cellParams = unpackStruct(params);
    
    % Execute the step
    dataOut = fun(dataIn, cellParams{:});

end

