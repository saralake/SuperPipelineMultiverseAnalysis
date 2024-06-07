
%% set standard bad electrodes

raw_Files = {...
    'PATHS_101/@rawPATHS_101_ASSR_20191120_025148/data_0raw_PATHS_101_ASSR_20191120_025148.mat'};


raw_Files = bst_process('CallProcess', 'process_channel_setbad', raw_Files, [], ...
    'sensortypes', 'E67,E73,E82,E91,E92,E102,E111,E120,E133,E145,E165,E174,E187,E199,E208, E209, E216,E217,E218,E219,E225,E226,E227,E228,E229,E230,E231,E232,E233,E234,E235, E236,E237,E238,E239,E240,E241,E242,E243,E244,E245,E246,E247,E248,E249,E250, E251,E252,E253,E254,E255,E256');

% write here the motivation why these electrodes are standardly removed.


% Process: Resample: 250Hz
resamp_Files = bst_process('CallProcess', 'process_resample', raw_Files, [], ...
    'freq',     250, ...
    'read_all', 0);

% Process: Band-pass:0.5Hz-48Hz
filt_Files = bst_process('CallProcess', 'process_bandpass', resamp_Files, [], ...
    'sensortypes', 'EEG', ...
    'highpass',    0.5, ...
    'lowpass',     48, ...
    'tranband',    0, ...
    'attenuation', 'strict', ...  % 60dB
    'ver',         '2019'C, ...  % 2019
    'mirror',      0, ...
    'read_all',    0);



% Process: Delete selected files
del_Files = bst_process('CallProcess', 'process_delete', resamp_Files, [], ...
    'target', 2);  % Delete selected folder






