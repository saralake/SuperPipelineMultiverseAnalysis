% SPMA_SAVEDATA - Save a data object. The saved data can be in different
% format depending on the module where it is saved.
%
% Usage:
%     >> SPMA_saveData(data)
%     >> SPMA_saveData(data, saveName)
%     >> SPMA_saveData(data, saveName, saveFolder)
%
% Inputs:
%    data        = [any] A set of data
%    saveName    = [string] The name of the saved file (default: the name
%           of the calling function)
%    saveFolder  = [string] The folder where to save the file (default: the
%           name of the module of the calling function)
%
%
% Authors: Alessandro Tonin, IRCCS San Camillo Hospital, 2024
% 
% See also: SAVE, POP_SAVESET

function SPMA_saveData(data, saveName, saveFolder)
    arguments (Input)
        data
        saveName string = ""
        saveFolder string = ""
    end

    %% Logger
    log = SPMA_loggerSetUp("general");

    %% Get folder and name automatically from the calling function
    if saveFolder == "" || saveName == ""
        [module, functionName] = SPMA_getModuleAndName(2);
        if saveFolder == ""
            saveFolder = module;
        end
        if saveName == ""
            saveName = functionName;
        end
    end

    %% Save
    
    % Check folder and create it if does not exist
    if ~exist(saveFolder, "dir")
        [success, message, ~] = mkdir(saveFolder);
        if ~success
            error(message)
        end
    end

    % clean save name removing extensions
    [~, saveName, ~] = fileparts(saveName);

    % Check data type
    dataType = SPMA_checkDataType(data);

    switch dataType
        case "EEGLAB"
            saveExt = 'set';
            saveName = sprintf("%s.%s", saveName, saveExt);
            % Save with EEGLAB function
            log.info(sprintf("Save EEGLAB dataset: %s", fullfile(saveFolder,saveName)))
            pop_saveset(data,...
                'filename', saveName,...
                'filepath', saveFolder,...
                'savemode', 'onefile', ...
                'version', '7.3')
        otherwise
            % Unknown type. Save a mat file
            log.warning("Unknown type")
            saveExt = 'mat';
            saveName = sprintf("%s.%s", saveName, saveExt);
            
            saveFullPath = fullfile(saveFolder, saveName);
            log.info(sprintf("Save matlab dataset: %s", fsaveFullPath))
            
            save(saveFullPath, "data", "-v7.3")
    end
end

