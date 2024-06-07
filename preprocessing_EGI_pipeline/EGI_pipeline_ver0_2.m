%% SCRIPT SINGLE-SUBJECT %%
clear all
cd('/mnt/raid/RU1/software/eeglab2020_0')
eeglab

% SET PROTOCOL PATH
% INPUT
or_project_path = '/mnt/raid/RU1/Raw_data/PATHS/';
% OUTPUT
preproc_path = '/mnt/raid/RU1/eeglab_data/EGI_pipeline_provaG/';

subj_list = {...
    'All'}


for iSubj = 1:length(subj_list)
    
    NO_FILES= 0; % initialize this variable (assume there are some files to process for the subject)
    
    
    % insert loop for subject here
    % input % Change the three lines below
    subj_name = subj_list{iSubj};
    or_subj_path = [subj_name, '/*/EEG_ORIG/*ASSR*'];
    or_subj_dir = dir([or_project_path, or_subj_path]);
    
    %output
    out_subj_path = [subj_name, '_preproc/'];
    mkdir([preproc_path, out_subj_path])
    % set to export folder
    cd([preproc_path, out_subj_path])
   
    
    % get date
    
    if length(or_subj_dir) > 1
        dates = zeros(1,2);
        ini_ses_labels = {'PRE', 'POST'}; % set initial session labels
        
        % get order of recording (for PRE-POST).
        for iD = 1:length(or_subj_dir)
            fold = or_subj_dir(iD).folder;
            date_i = regexp(fold, '\d{8}'); % get wheere there are 8 numbers (that is where there is a date)
            date = str2num(fold(date_i:date_i+7));
            dates(iD) = date;
        end;
        [~, DateOrder] = sort(dates);
        
        ses_names = ini_ses_labels(DateOrder);
        
    elseif length(or_subj_dir) == 1
        
        ses_names = {'PRE'}; % in case only one session is present
    else
        NO_FILES = 1; % case in which there are no files
        report = fopen([subj_name, '_report.txt'], 'w');
        fprintf(report, '%s', ['no files for this participant']);
        fclose(report)   
    end
    
    if ~NO_FILES % proceed only if there are files
        
        for iSes=1:length(ses_names)
            
            curr_ses_name = ses_names{iSes};
            
            %% initialize report
            report = fopen([subj_name, curr_ses_names, '_report.txt'], 'w');
            
            %%% !!!!! GET HERE FILES
            curr_file_fullpath = [or_subj_dir(iSes).folder, '/', or_subj_dir(iSes).name]
            
            EEG.etc.eeglabvers = '2020.0'; % this tracks which version of EEGLAB is being used, you may ignore it
            
            %% PRE-PROCESSING START HERE
            %% PHASE 1
            % 1) import data
            EEG = pop_readegimff(curr_file_fullpath)
            
            %%  check for events
            DIN1_present = any(strcmp('DIN1', {EEG.event.type}));
            DIN2_present = any(strcmp('DIN1', {EEG.event.type}));
            
            if DIN1_present
                rel_event = 'DIN1'
            elseif ~DIN1_present & DIN2_present
                rel_event = 'DIN2'
            else
                rel_event = 'no_events';
            end;
            
            %% first line of report:
           fprintf(report, '%s', ['Events: ', rel_event]);
           fprintf(fid, '\n', '');
            
            if ~strcmp(rel_event, 'no_events')
                
                EEG.setname= subj_name;
                EEG = eeg_checkset( EEG );
                % 2) resample
                EEG = pop_resample( EEG, 250);
                EEG = eeg_checkset( EEG );
                % 3) filter
                EEG = pop_eegfiltnew(EEG, 'locutoff',1,'hicutoff',48);
                EEG = eeg_checkset( EEG );
                % 4) import ChannelFile <- NEW !!!!!INSERT SCRIPT UPLOADS!!!!\\!!!
                EEG = eeg_checkset( EEG );
                EEG=pop_chanedit(EEG, 'load',{'/mnt/raid/RU1/Raw_data/PATHS/PATHS_105/ses-20200115/NEURONAV/PATHS_105_sensposMR_rotated_padded_corrected.sfp','filetype','sfp'},'rplurchanloc',1,'rplurchanloc',0,'settype',{'','EEG'},'rplurchanloc',1);
                % 5) exclude channels
                EEG = pop_select( EEG, 'nochannel',{'E67','E73','E82','E91','E92','E102','E111','E120','E133','E145','E165','E174','E187','E199','E208','E209','E216','E217','E218','E219','E225','E226','E227','E228','E229','E230','E231','E232','E233','E234','E235','E236','E237','E238','E239','E240','E241','E242','E243','E244','E245','E246','E247','E248','E249','E250','E251','E252','E253','E254','E255','E256'});
                EEG = eeg_checkset( EEG );
                % 6) Remove Start/End BAD
                EEG_end_sec = EEG.times(end)/1000;
                EEG = pop_select( EEG,'notime',[5 EEG_end_sec-5] );
                EEG = eeg_checkset( EEG );
                % 7) Clean data
                EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion',5,'ChannelCriterion',0.8,'LineNoiseCriterion',4,'Highpass','off','BurstCriterion','off','WindowCriterion',0.25,'BurstRejection','off','Distance','Euclidian','WindowCriterionTolerances',[-Inf 50] );
                EEG = eeg_checkset( EEG );
                %SAVING results STEP1
                EEG = pop_saveset( EEG, 'filename',[subj_name, '_', curr_ses_name, '_clean.set'],'filepath', [preproc_path, out_subj_path]);
                
               %% PHASE 2
                % 8) ICA
                EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'interrupt','on'); % VEDERE COME SELEZIONARE NUMERO DI COMPONENTI PRIMA
                EEG = eeg_checkset( EEG );
                % 9) ICLabel + IC Flag
                EEG = pop_iclabel(EEG, 'default');
                EEG = eeg_checkset( EEG );
                EEG = pop_icflag(EEG, [NaN NaN;0.9 1;0.9 1;0.9 1;NaN NaN;0.5 1;0.9 1]); %MODIFIED
                EEG.setname = [subj_name, '_phase1']; % pre-ica
                EEG = eeg_checkset( EEG );
                % 10) remove artifactual components
                Rej_comps = find(EEG.reject.gcompreject);
                csvwrite([preproc_path, out_subj_path, subj_name, '_rejected_comps.txt'], Rej_comps);
                EEG = pop_subcomp( EEG, Rej_comps, 0);
                %SAVING results PHASE2
                EEG = pop_saveset( EEG, 'filename',[subj_name, '_', curr_ses_name, '_postICA.set'],'filepath', [preproc_path, out_subj_path])
                
                %% PHASE 3
                % 11) Clean data (1)
                EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion',5,'ChannelCriterion',0.8,'LineNoiseCriterion',4,'Highpass','off','BurstCriterion',20,'WindowCriterion',0.25,'BurstRejection','on','Distance','Euclidian','WindowCriterionTolerances',[-Inf 7] );
                EEG = eeg_checkset( EEG );
                % SAVING results PHASE3
                EEG = pop_saveset( EEG, 'filename',[subj_name, '_', curr_ses_name, '_clean1.set'],'filepath', [preproc_path, out_subj_path]);
                
                %% PHASE 4
                % 12) Epoching  !!!!!! insert here if per DIN1 vs DIN2
                EEG = pop_epoch( EEG, rel_event, [-1.5 1.5], 'newname', [subj_name, '_phase2'], 'epochinfo', 'yes');
                EEG = eeg_checkset( EEG );
                EEG = pop_rmbase( EEG, [-100 0] ,[]);
                EEG = eeg_checkset( EEG );
                % SAVING results PHASE4
                EEG = pop_saveset( EEG, 'filename',[subj_name, '_', curr_ses_name, '_epoched.set'],'filepath', [preproc_path, out_subj_path]);
                
                
                
                
            end; %% end check for events
            fclose(report);
        end;
        
    end;
    
end;


% capire come EEGLAB tratta aventi.
%
% for iE=1:length(EEG.event)
%     EEG.event(iE).duration=0;
% end;
%  EEG = eeg_checkset( EEG );

%%
% REPORT
% fid = fopen('prova_report', 'w');
% fprintf(fid, '%s ', myComment); % print comment (first row)
% fprintf(fid, '\n', '');
% fclose(fid)
