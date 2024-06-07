preproc_path = '/mnt/raid/RU1/eeglab_data/EGI_pipeline_provaG/';
curr_ses_name = 'PRE';
curr_file_fullpath = '/mnt/raid/RU1/Raw_data/PATHS/PATHS_101/ses-20191220/EEG_ORIG/PATHS_101_ASSR_POST_20191220_025100.mff'

subj_name = 'PATHS_101'
out_subj_path = [subj_name, '_preproc/'];
mkdir([preproc_path, out_subj_path])


EEG.etc.eeglabvers = '2020.0'; % this tracks which version of EEGLAB is being used, you may ignore it

%% PRE-PROCESSING START HERE
%% PHASE 1
% 1) import data
EEG = pop_readegimff(curr_file)
EEG = eeg_checkset( EEG );
%% insert here a check for events
% any(strcmp('DIN1', {EEG.event.type}))

EEG.setname= subj_name;
EEG = eeg_checkset( EEG );
% 2) resample
EEG = pop_resample( EEG, 250);
EEG = eeg_checkset( EEG );
% 3) filter
EEG = pop_eegfiltnew(EEG, 'locutoff',0.5,'hicutoff',48);
EEG = eeg_checkset( EEG );

% 4) select time excluding first 5 and last 5 seconds
EEG_end_sec = EEG.times(end)/1000
EEG = pop_select( EEG,'notime',[5 EEG_end_sec-5] );
EEG = eeg_checkset( EEG );

% 5) exclude channels
EEG = pop_select( EEG, 'nochannel',{'E67','E73','E82','E91','E92','E102','E111','E120','E133','E145','E165','E174','E187','E199','E208','E209','E216','E217','E218','E219','E225','E226','E227','E228','E229','E230','E231','E232','E233','E234','E235','E236','E237','E238','E239','E240','E241','E242','E243','E244','E245','E246','E247','E248','E249','E250','E251','E252','E253','E254','E255','E256'});
EEG = eeg_checkset( EEG );
% 6) Clean data
EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion',5,'ChannelCriterion',0.8,'LineNoiseCriterion',4,'Highpass','off','BurstCriterion',20,'WindowCriterion',0.25,'BurstRejection','on','Distance','Euclidian','WindowCriterionTolerances',[-Inf 7] );
EEG = eeg_checkset( EEG );
% 7) ICA
EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'interrupt','on'); % VEDERE COME SELEZIONARE NUMERO DI COMPONENTI PRIMA
EEG = eeg_checkset( EEG );
% 7 ) ICLabel + IC Flag
EEG = pop_iclabel(EEG, 'default');
EEG = eeg_checkset( EEG );
EEG = pop_icflag(EEG, [NaN NaN;0.9 1;0.9 1;0.9 1;NaN NaN;NaN NaN;NaN NaN]);
EEG.setname = [subj_name, '_phase1']; % pre-ica
EEG = eeg_checkset( EEG );

EEG = pop_saveset( EEG, 'filename',[subj_name, '_', curr_ses_name, '_phase1.set'],'filepath', [preproc_path, out_subj_path]);

%% PHASE 2
% 8) remove artifactual components
Rej_comps = find(EEG.reject.gcompreject);
csvwrite([preproc_path, out_subj_path, subj_name, '_rejected_comps.txt'], Rej_comps);

EEG = pop_subcomp( EEG, Rej_comps, 0);

% !!!!!! insert here if per DIN1 vs DIN2
EEG = pop_epoch( EEG, {  'DIN1'  }, [-1.5 1.5], 'newname', [subj_name, '_phase2'], 'epochinfo', 'yes');
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [-100 0] ,[]);
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename',[subj_name, '_', curr_ses_name, '_phase2.set'],'filepath', [preproc_path, out_subj_path]);
