%% SCRIPT SINGLE-SUBJECT 
%%
% This script is the one continuosly edited by me(Sara) to obtain the
% perfect pipeline 

cd('/mnt/raid/RU1/software/eeglab2020_0')
eeglab

% SET PROTOCOL PATH
% INPUT
or_project_path = '/mnt/raid/RU1/Raw_data/PATHS/';
% OUTPUT
preproc_path = '/mnt/raid/RU1/eeglab_data/EGI_pipeline_prova/';

% insert loop for subject here
% input % Change the three lines below
subj_name = 'PATHS_101';
or_subj_path = 'PATHS_101/ses_20191120/EEG_ORIG/';
curr_subj = 'PATHS_101_ASSR_20191120_025148.mff';

%output
out_subj_path = [subj_name, '_preproc/'];


%% PHASE 1
% 1) import data
EEG = pop_mffimport([or_project_path, or_subj_path, curr_subj])
eeglab redraw;

%% insert here a check for events
% any(strcmp('DIN1', {EEG.event.type}))

EEG.setname= subj_name;
EEG = eeg_checkset( EEG );
% 2) resample 
EEG = pop_resample( EEG, 250);
EEG = eeg_checkset( EEG );
% 3) filter
EEG = pop_eegfiltnew(EEG, 'locutoff',1,'hicutoff',48);
EEG = eeg_checkset( EEG );
% 4) import ChannelFile (new)
EEG = eeg_checkset( EEG );
EEG=pop_chanedit(EEG, 'load',{'/mnt/raid/RU1/Raw_data/PATHS/PATHS_101/ses_20191120/NEURONAV/PATHS_101_PRE_sensposMR_fix.sfp','filetype','sfp'},'rplurchanloc',1,'rplurchanloc',0,'settype',{'','EEG'},'rplurchanloc',1);
% 5) exclude bad channels (outer ring-cheeks)
EEG = pop_select( EEG, 'nochannel',{'E67','E73','E82','E91','E92','E102','E111','E120','E133','E145','E165','E174','E187','E199','E208','E209','E216','E217','E218','E219','E225','E226','E227','E228','E229','E230','E231','E232','E233','E234','E235','E236','E237','E238','E239','E240','E241','E242','E243','E244','E245','E246','E247','E248','E249','E250','E251','E252','E253','E254','E255','E256'});
EEG = eeg_checkset( EEG ); 
% 6) Clean data
EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion',5,'ChannelCriterion',0.8,'LineNoiseCriterion',4,'Highpass','off','BurstCriterion','off','WindowCriterion',0.25,'BurstRejection','off','Distance','Euclidian','WindowCriterionTolerances',[-Inf 50] );
EEG = eeg_checkset( EEG );
% 7) ICA
EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'interrupt','on'); % VEDERE COME SELEZIONARE NUMERO DI COMPONENTI PRIMA
EEG = eeg_checkset( EEG );
% 8) ICLabel + IC Flag
EEG = pop_iclabel(EEG, 'default');
EEG = eeg_checkset( EEG );
EEG = pop_icflag(EEG, [NaN NaN;0.9 1;0.9 1;0.9 1;NaN NaN;0.5 1;0.9 1]); %new adding EKG,ChannelNoise and others
EEG.setname = [subj_name, '_phase1']; % pre-ica
EEG = eeg_checkset( EEG );

% SAVE PHASE 1
EEG = pop_saveset( EEG, 'filename',[subj_name, '_phase1preICAchan.set'],'filepath', [preproc_path, out_subj_path]);

%% PHASE 2
% 9) remove artifactual components
Rej_comps = find(EEG.reject.gcompreject); 
csvwrite([preproc_path, out_subj_path, subj_name, '_rejected_comps.txt'], Rej_comps);
EEG = pop_subcomp( EEG, Rej_comps, 0);
EEG = pop_saveset( EEG, 'filename',[subj_name, '_phase2postICAchan.set'],'filepath', [preproc_path, out_subj_path]);
% 10) Clean data 2.0 (w/ default parameters)
EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion',5,'ChannelCriterion',0.8,'LineNoiseCriterion',4,'Highpass','off','BurstCriterion',20,'WindowCriterion',0.25,'BurstRejection','on','Distance','Euclidian','WindowCriterionTolerances',[-Inf 7] );
EEG = eeg_checkset( EEG );
% 11) Epoching (better doing this step su BST)
EEG = pop_epoch( EEG, {  'DIN2'  }, [-1.5 1.5], 'newname', [subj_name, '_phase2'], 'epochinfo', 'yes');
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [-100 0] ,[]);
EEG = eeg_checkset( EEG );
% SAVE PHASE 2
EEG = pop_saveset( EEG, 'filename',[subj_name, '_phase3.set'],'filepath', [preproc_path, out_subj_path]);

