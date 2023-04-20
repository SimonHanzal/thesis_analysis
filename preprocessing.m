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
i = 1;
recording_ending = '_e';
save_as = '_m_prefiltered_2'
participant_list = {
'10000','10001','10002','10003','10005','10007','10008','10009','10010',...
'10501','10503','10504','10505','10506','10507','10508','10509','10510',...
'15000','15001','15002','15003','15005','15006','15007','15008','15009',...
'15501','15502','15504','15505','15506','15507','15510'};
other_participant_List = {'10004','10006','10502','15004','15508','15509'};

[a, participant_list_size] = size(participant_list);
participant = char(participant_list(i));
% EEGLAB start
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

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

%% Individual analysis

% Detrend
EEG.data = detrend(EEG.data);

% Filter
EEG = pop_eegfiltnew(EEG, 0.5, 40, [], 0, [], 0);

% Epoch
EEG = pop_epoch(EEG, {'S  1'  'S  2'  'S  3' 'S  4' 'S  5'  'S  6' ...
    'S  7' 'S  8' 'S  9' 'S 10'}, [-2  2]);

% Rereference
EEG = pop_reref(EEG, [], 'exclude', [31 32]); %Exclude eye electrodes in this run

% Save
EEG = pop_saveset( EEG, 'filename',strcat(participant,'_filterraw.set'),'filepath','C:\\Users\\simonha\\OneDrive - University of Glasgow\\research\\data\\exp1_data\\ica\\');
eeglab redraw;

% Load in weights file
recordingEnding = '_m_prefiltered_2';
analysed_directory = strcat(directory, 'exp1_data\ica\');
recording = strcat(participant,recordingEnding,'.set');
[EEG ALLEEG CURRENTSET] = eeg_retrieve(ALLEEG,1);
EEG = pop_loadset('filename',recording,'filepath', analysed_directory);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );

%Check consistency
EEG = eeg_checkset(EEG);

%Read in channel locs
EEG = pop_chanedit(EEG, 'lookup',chanloc_path);

%Switch back to the original
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'retrieve',1,'study',0); 

% Load in ica_weights
EEG = pop_editset(EEG, 'run', [], 'icaweights', 'ALLEEG(2).icaweights', 'icasphere', 'ALLEEG(2).icasphere', 'icachansind', 'ALLEEG(2).icachansind');
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
eeglab redraw;

%Label and reject components                                                                                                                                       
file_name = sprintf(strcat(participant,'_m_prefiltered_guide.txt'));    
if isfile(file_name)
    open(file_name)
else
    dlmwrite(file_name, 1);                                              
    open(file_name); 
end

%% Manual section
                                                          
% highlight ICAs                                                                                                    
% Tools/ Classify components using ICLabel / Label components, Use criteria.                                         
% Revise choice.                                                                                                                     
                                                                                                                               
% Remove and make note of remaining bad trials
% Inform through this tagging trials with over 3SD peaks.
var1 = (1:64);
trial_no = size(EEG.data);
for i = 1:trial_no(3) 
    channel_peaks(i) = max(max(abs(EEG.data(:,:,i))));
end
mean_ampli = mean(channel_peaks);
sd_ampli = std(channel_peaks);
cut_off = mean_ampli+3*sd_ampli;
[logical, indeces] = find(channel_peaks >= cut_off);

%Inspect indeces

% Remove final trials, interpolate

% Save
EEG = pop_saveset( EEG, 'filename',strcat(participant,'_clean.set'),'filepath','C:\\Users\\simonha\\OneDrive - University of Glasgow\\research\\data\\exp1_data\\clean\\');
