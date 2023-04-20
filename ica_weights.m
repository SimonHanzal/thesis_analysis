clear all

%% Add-ons
% EEG processing packages
fieldtrip_path = 'C:\Users\simonha\AppData\Roaming\MathWorks\MATLAB Add-Ons\Collections\FieldTrip';
eeglab_path = 'C:\Users\simonha\AppData\Roaming\MathWorks\MATLAB Add-Ons\Collections\EEGLAB';
% channel locations
chanloc_path = 'C:\Users\simonha\AppData\Roaming\MathWorks\MATLAB Add-Ons\Collections\EEGLAB\plugins\dipfit4.3\standard_BEM\elec\standard_1005.elc';
% adding to path
addpath(eeglab_path, fieldtrip_path)

directory = 'C:\Users\simonha\OneDrive - University of Glasgow\research\data\'
addpath(directory)
cd(directory)

%% SETTINGS

% Recording and participant type choice
recording_ending = '_e';
save_as = '_m_prefiltered_2'
participant_list = {
'10000','10001','10002','10003','10005','10007','10008','10009','10010',...
'10501','10503','10504','10505','10506','10507','10508','10509','10510',...
'15000','15001','15002','15003','15005','15006','15007','15008','15009',...
'15501','15502','15504','15505','15506','15507','15510'};
other_participant_List = {'10004','10006','10502','15004','15508','15509'}

[a, participant_list_size] = size(participant_list);

% EEGLAB start
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
eeglab redraw;


%% Analysis loop

i = 1
for i = 1:participant_list_size %1 if you only want to do a concrete participant
    % Names
    participant = char(participant_list(i));
    analysed_directory = strcat(directory, 'exp1_data\', participant, '\eeg\raw\');
    recording = strcat(participant,recording_ending,'.vhdr');

    cd(analysed_directory);

    % Read in file
    EEG = pop_loadbv(analysed_directory, recording);
    % Check consistency
    EEG = eeg_checkset(EEG);
    % Read in channel locs
    EEG = pop_chanedit(EEG, 'lookup',chanloc_path);

    eeglab redraw;

    % Detrend
    EEG.data = detrend(EEG.data);
    
    % Filter
    EEG = pop_eegfiltnew(EEG, 2, 45, [], 0, [], 0);

    % Rereference
    EEG = pop_reref(EEG, [], 'exclude', [31 32]);

    % ICA
    EEG = pop_runica(EEG, 'extended',1,'interupt','on', 'chanind', [1:64]);

    % Epoch
    EEG = pop_epoch(EEG, {'S  1'  'S  2'  'S  3' 'S  4' 'S  5'  'S  6' ...
        'S  7' 'S  8' 'S  9' 'S 10'}, [-2  2]); %'epochinfo', 'yes');
    
    % Save                                                                                                       
    EEG = pop_saveset( EEG, 'filename',strcat(participant, save_as, '.set'),'filepath','C:\\Users\\simonha\\OneDrive - University of Glasgow\\research\\data\\exp1_data\\ica\\');
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
end