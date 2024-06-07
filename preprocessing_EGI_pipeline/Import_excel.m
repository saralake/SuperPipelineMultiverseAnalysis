% change path to the path containing the excel file)
cd '/mnt/raid/RU1/Raw_data/PATHS/';
% IMPORT EXCEL NAMES

[~, ~, ID_names] = xlsread('PATHS_files.xls', 'ID');
[~, ~, EEG_files] = xlsread('PATHS_files.xls', 'EEG');
[~, ~, NEURONAV_files] = xlsread('PATHS_files.xls', 'NEURONAV');
[~, ~, OUT_DIRs] = xlsread('PATHS_files.xls', 'OUT_DIR');


all_IDs = ID_names(2:end,1);

for iSubj = 1:length(all_IDs)
    
    curr_subj = ID_names(iSubj+1, 1) % note, the plus 1 is to skip the column name.
    curr_eeg_file = EEG_files(iSubj+1, 2); % note, the plus 1 is to skip the column name.
    curr_nn_file = NEURONAV_files(iSubj+1, 2); % note, the plus 1 is to skip the column name.
    curr_out_dir = OUT_DIRs(iSubj+1, 2)  % note, the plus 1 is to skip the column name.
    
    % INSERT CODE HERE AND USE THE APPROPRIATE VARIABLE!

end;

