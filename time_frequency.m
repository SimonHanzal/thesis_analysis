
%% Add-ons
clear all

% EEG processing packages
fieldtrip_path = 'C:\Users\simonha\AppData\Roaming\MathWorks\MATLAB Add-Ons\Collections\FieldTrip';
eeglab_path = 'C:\Users\simonha\AppData\Roaming\MathWorks\MATLAB Add-Ons\Collections\EEGLAB';
% channel locations
chanloc_path = 'C:\Users\simonha\AppData\Roaming\MathWorks\MATLAB Add-Ons\Collections\EEGLAB\plugins\dipfit4.3\standard_BEM\elec\standard_1005.elc';
% Viridis
viridis_path = ('C:\Users\simonha\AppData\Roaming\MathWorks\MATLAB Add-Ons\Collections\cbrewer _ colorbrewer schemes for Matlab\cbrewer\cbrewer');

% adding to path
addpath(eeglab_path, fieldtrip_path, viridis_path)

%% Loading in
% Dataset selection functionality
participant_list = {'10000', '10001','10002','10003', '10005','10007','10008','10009','10010',...
                   '10501','10503','10504','10505','10506','10507','10508','10509','10510',...
                   '15000','15001','15002','15003','15005','15006','15007','15008','15009',...
                   '15501','15502','15504','15505','15506','15507','15510'};
    


type_logic = 5; %nogo 1, go 2, all 3, first 4, last 5
sets = '_e';
lower_limit = -2;
upper_limit = 2;
saving = 0;
loop_all = 0;

if loop_all == 1
    loop_lenth = length(participant_list)
else
    loop_length = 2
end

directory = 'C:\Users\simonha\OneDrive - University of Glasgow\research\data\'
analysed_directory = strcat(directory, 'exp1_data\just_ica'); 

% Path settings, do not touch!
restoredefaultpath; savepath;
addpath(fieldtrip_path);
ft_defaults;
addpath(analysed_directory, eeglab_path)
cd(analysed_directory);

% Load data
[ALLEEG EEG CURRENTSET ALLCOM]  = eeglab;

%% Frequency analysis
i = 1;
for i = 1:loop_length

    % Load
    participant = char(participant_list(i));
    recording = strcat(participant, sets, '.set');
    EEG = pop_loadset('filename',recording,'filepath',analysed_directory);
    EEG = eeg_checkset(EEG);
    eeglab redraw;
    
    % Settings
    cfg = [];
    cfg.demean ='yes';
    cfg.trialdef.eventtype = 'Stimulus';
    end_block_one = max(find([EEG.event.urevent].' <= 91));
    beginning_block_eight = min(find([EEG.event.bvmknum].' >= 628));
    end_block_eight = max(find([EEG.event.epoch].' >= 500));
    
    if type_logic == 1
        type = 'nogo';
        cfg.trialdef.eventvalue = {'S  3' 'S  6'};
        EEG = pop_epoch(EEG, {'S  3' 'S  6'}, [lower_limit  upper_limit], 'epochinfo', 'yes');

    elseif type_logic == 2
        type = 'go';
        cfg.trialdef.eventvalue = {'S  0' 'S  1' 'S  2' 'S  4' 'S  5' 'S  7' 'S  8' 'S  9'};
        EEG = pop_epoch(EEG, {'S  0' 'S  1' 'S  2' 'S  4' 'S  5' 'S  7' 'S  8' 'S  9'}, [lower_limit  upper_limit], 'epochinfo', 'yes');
    elseif type_logic == 3
        type = 'all';
        cfg.trialdef.eventvalue = {'S  0' 'S  1' 'S  2' 'S  3' 'S  4' 'S  5' 'S  6' 'S  7' 'S  8' 'S  9'};
        EEG = pop_epoch(EEG, {'S  0' 'S  1' 'S  2' 'S  3' 'S  4' 'S  5' 'S  6' 'S  7' 'S  8' 'S  9'}, [lower_limit  upper_limit], 'epochinfo', 'yes');
    elseif type_logic == 4
        type = 'first';
        %cfg.?
        EEG = pop_select(EEG, 'trial', [1:end_block_one]);
    elseif type_logic == 5
        type = 'last';
        %cfg.trials = [beginning_block_eight:end_block_eight];
        EEG = pop_select(EEG, 'trial', [beginning_block_eight:end_block_eight]);
    else
        warning = 'warning';
    end
    
    %ft_defaults;
    
    cfg.trialfun = 'ft_trialfun_general';
    cfg.continuous = 'yes';
    data = ft_timelockanalysis(struct('keeptrials','yes'), eeglab2fieldtrip(EEG,'preprocessing'));
    data = ft_preprocessing(cfg, data); %May still not work because I am converting from one format to another.
    cfg.method = 'mtmconvol';
    cfg.taper = 'hanning';
    cfg.foi = 2:1/3:40;            
    cfg.t_ftimwin = 6./cfg.foi;         
    cfg.toi = -2:0.02:1;      
    cfg.keeptrials = 'yes';
    cfg.pad = 'maxperlen';        
    cfg.polyremoval = 1;             
    cfg.keeptrials = 'yes';
    data = ft_freqanalysis(cfg, data);
    data.powspctrm = squeeze(mean(data.powspctrm,1));
    data.dimord = 'chan_freq_time';
    cd('C:\Users\simonha\OneDrive - University of Glasgow\research\data\exp1_data\permutation')
    if saving == 1
        save(char([strcat(participant, sets, '_', type,'.mat')]), 'data', '-v7.3')
    end
end

