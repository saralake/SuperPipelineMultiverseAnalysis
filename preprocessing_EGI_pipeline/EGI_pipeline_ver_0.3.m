%% SCRIPT SINGLE-SUBJECT %%
clear all
cd('/mnt/raid/RU1/software/eeglab2020_0')
eeglab

% SET PROTOCOL PATH
% INPUT
or_project_path = '/mnt/raid/RU1/Raw_data/PATHS/';
% OUTPUT
preproc_path = '/mnt/raid/RU1/Raw_data/PATHS_Preproc/';

% Select path excel file
cd '/mnt/raid/RU1/Raw_data/PATHS/';

% IMPORT EXCEL NAMES

[~, ~, ID_names] = xlsread('PATHS_files.xls', 'ID');
[~, ~, EEG_files] = xlsread('PATHS_files.xls', 'EEG');
[~, ~, NEURONAV_files] = xlsread('PATHS_files.xls', 'NEURONAV');
%[~, ~, OUT_DIRs] = xlsread('PATHS_files.xls', 'OUT_DIR');


all_IDs = ID_names(2:end,1);

for iSubj = 1:length(all_IDs)
   
    
    curr_subj = ID_names(iSubj+1, 1) % note, the plus 1 is to skip the column name.
    curr_eeg_file = EEG_files(iSubj+1, 2); % note, the plus 1 is to skip the column name.
    curr_neuronav_file = NEURONAV_files(iSubj+1, 2); % note, the plus 1 is to skip the column name.
    curr_nn_file = char(curr_neuronav_file)
    %curr_out_dir = OUT_DIRs(iSubj+1, 2)  % note, the plus 1 is to skip the column name.

    EEG.etc.eeglabvers = '2020.0'; % this tracks which version of EEGLAB is being used, you may ignore it
    
    %% PRE-PROCESSING START HERE
    %% PHASE 1
    % 1) import data
    EEG = pop_mffimport(curr_eeg_file); %,{'code'}; 
      
    %% create a subject directory in the preproc_folder
       curr_subj_name = all_IDs{iSubj};   
       out_subj_path = [curr_subj_name, '_preproc/']
       mkdir([preproc_path, out_subj_path])
       cd([preproc_path, out_subj_path])
       
    %%  check for events
    DIN1_present = any(strcmp('DIN1', {EEG.event.type}));
    DIN2_present = any(strcmp('DIN2', {EEG.event.type}));
    
        if DIN1_present
            rel_event = 'DIN1'
        elseif ~DIN1_present & DIN2_present
            rel_event = 'DIN1'
        else
            rel_event = 'no_events';
        end;
        
       % create an event report
       report = fopen([curr_subj_name, '_event.txt'], 'w');
       fprintf(report, '%s', ['Events: ', rel_event]);
       fclose(report);

    
        if ~strcmp(rel_event, 'no_event')

            % set name of the subject
            EEG.setname= curr_subj;
            EEG = eeg_checkset( EEG );
            % 2) resample
            EEG = eeg_checkset( EEG );
            EEG = pop_resample( EEG, 250);
            % 3) filter
            EEG = pop_eegfiltnew(EEG, 'locutoff',0.5,'hicutoff',48);
            EEG = eeg_checkset( EEG );
            % 4) import ChannelFile 
            EEG = eeg_checkset( EEG );
            EEG = pop_chanedit(EEG, 'load',{curr_nn_file ,'filetype','sfp'},'rplurchanloc',1,'rplurchanloc',0,'settype',{'','EEG'},'rplurchanloc',1);
            % 5) exclude channels
            EEG = pop_select( EEG, 'nochannel',{'E67','E73','E82','E91','E92','E102','E111','E120','E133','E145','E165','E174','E187','E199','E208','E209','E216','E217','E218','E219','E225','E226','E227','E228','E229','E230','E231','E232','E233','E234','E235','E236','E237','E238','E239','E240','E241','E242','E243','E244','E245','E246','E247','E248','E249','E250','E251','E252','E253','E254','E255','E256'});
            EEG = eeg_checkset( EEG );
            % 6) Remove Start/End BAD
            EEG_end_sec = EEG.times(end)/1000;
            EEG = pop_select(EEG,'time',[5 EEG_end_sec-5] );
            EEG = eeg_checkset( EEG );
            % 7) Clean data(clean with loose parameters to exclude only
            % mayor artifacts)
            EEG_chans_6 = {EEG.chanlocs.labels}; % get labels of step 6 EEG
            EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion',5,'ChannelCriterion',0.8,'LineNoiseCriterion',4,'Highpass','off','BurstCriterion','off','WindowCriterion',0.25,'BurstRejection','off','Distance','Euclidian','WindowCriterionTolerances',[-Inf 50] );
            EEG = eeg_checkset( EEG );
            EEG_chans_7 = {EEG.chanlocs.labels}; % get labels of step 7 EEG
            EEG_chans_7_excluded = setdiff(EEG_chans_6, EEG_chans_7); % find labels in 6 not in 7.
            csvwrite([preproc_path, out_subj_path, curr_subj_name, '_clean_bad_channels.txt'], EEG_chans_7_excluded);
            %SAVING results STEP1
            EEG = pop_saveset( EEG, 'filename',[curr_subj_name, '_', '_clean.set'],'filepath', [preproc_path, out_subj_path]);

            %% PHASE 2
            % 8) ICA
            EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'interrupt','on'); 
            EEG = eeg_checkset( EEG );
            % 9) ICLabel + IC Flag
            EEG = pop_iclabel(EEG, 'default');
            EEG = eeg_checkset( EEG );
            EEG = pop_icflag(EEG, [NaN NaN;0.9 1;0.9 1;0.9 1;NaN NaN;0.5 1;0.9 1]);
            EEG.setname = [curr_subj_name, '_phase1']; % pre-ica
            EEG = eeg_checkset( EEG );
            % 10) remove artifactual components
            Rej_comps = find(EEG.reject.gcompreject);
            csvwrite([preproc_path, out_subj_path, curr_subj_name, '_rejected_comps.txt'], Rej_comps);
            EEG = pop_subcomp(EEG, Rej_comps, 0);
            %SAVING results PHASE2
            EEG = pop_saveset( EEG, 'filename',[curr_subj_name, '_', '_postICA.set'],'filepath', [preproc_path, out_subj_path])

            %% PHASE 3
            % 11) Clean data (1)
            EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion',5,'ChannelCriterion',0.8,'LineNoiseCriterion',4,'Highpass','off','BurstCriterion',20,'WindowCriterion',0.25,'BurstRejection','on','Distance','Euclidian','WindowCriterionTolerances',[-Inf 7] );
            EEG = eeg_checkset( EEG );
            % SAVING results PHASE3
            EEG = pop_saveset( EEG, 'filename',[curr_subj_name, '_', '_clean1.set'],'filepath', [preproc_path, out_subj_path]);

            %% PHASE 4
            % 12) Epoching  !!!!!! insert here if per DIN1 vs DIN2
            EEG = pop_epoch(EEG, {rel_event}, [-1.5 1.5], 'newname', [curr_subj_name, '_clean1.set'], 'epochinfo', 'yes');
            EEG = eeg_checkset( EEG );
            EEG = pop_rmbase( EEG, [-100 0] ,[]);
            EEG = eeg_checkset( EEG );
            % SAVING results PHASE4
            EEG = pop_saveset( EEG, 'filename',[curr_subj_name, '_', '_epoched.set'],'filepath', [preproc_path, out_subj_path]);

        
        end %% end check for events
           
        
        
    end;
