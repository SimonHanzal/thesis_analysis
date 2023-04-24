cd('C:\Users\simonha\OneDrive - University of Glasgow\research\analysis\thesis_analysis')

channel_locations = EEG.chanlocs.labels;
cd(analysed_directory)
save(strcat('channel_locations.mat'), 'channel_locations', '-v7.3')

% Motivation participants
participant_list = {'10000', '10001','10002','10003', '10004','10005','10006','10007','10008','10009','10010',...
                   '10501','10503','10504','10505','10506','10507','10508','10509','10510',...
                   '15000','15001','15002','15005','15007','15009',...
                   '15501','15504','15505','15506','15507','15509', '15510'};
               
               
% Motivation notes
positions_high = [3 5 7 9 11 14 16 18 20];
positions_low = [1 2 4 6 8 10 12 13 15 17 19];
positions_high_all = [3 5 7 9 11 14 16 18 20 21 23 28 30 33];
positions_low_all = [1 2 4 6 8 10 12 13 15 17 19 22 24 25 26 27 29 31 32];
positions_low_inter = [1 2 4 5 6 8 10 11 13 15 17 20 22 23 24 25 27 29];
positions_high_inter = [3 7 9 12 14 16 18 19 21 26 28 30];
motivate_l = [2, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1,...
    2, 2, 1, 2, 1, 2, 1, 20, 1,...
    1, 2, 1, 2, 2, 2, ...
    2, 1, 2, 1, 2, 2, 1];


% Combination

participant_list = {'10000', '10001','10002','10003', '10005','10007','10008','10009','10010',...
                   '10501','10503','10504','10505','10506','10507','10508','10509','10510',...
                   '15000','15001','15002','15005','15007','15009',...
                   '15501','15504','15505','15506','15507','15510'};
               
               

%Just preserved young motivated
participantList = {'10002','10008','10010',...
    '10504', '10506', '10508', '10510'}

%Just preserved young non-motivated
participantList = {'10000','10001','10003','10005','10007','10009',...
    '10501', '10503', '10505', '10507', '10509'}


% Double comparisons

%Unmotivated
group_change_12                    = data;
group_change_12.dimord             = 'chan_freq_time';
group_change_12.time               = group_change_12.time(extract_time_start:extract_time_end);
group_change_12.freq               = group_change_12.freq(extract_power_start:extract_power_end);
group_change_12.powspctrm          = group2_change.powspctrm - group1_change.powspctrm;


group3                          = data;
group3.time                     = group3.time(extract_time_start:extract_time_end);
group3.freq                     = group3.freq(extract_power_start:extract_power_end);
if age_extraction == 1
    group3.powspctrm            = compilation(1:18,:,:,:);
    group3.dimord               = 'subj_chan_freq_time';
else
    group3.powspctrm            = compilation;
    group3.dimord               = 'subj_chan_freq_time';
end
group4                          = data;
group4.time                     = group4.time(extract_time_start:extract_time_end);
group4.freq                     = group4.freq(extract_power_start:extract_power_end);
if age_extraction == 1
    group4.powspctrm            = compilation(19:34,:,:,:);
    group4.dimord               = 'subj_chan_freq_time';
else
    group4.powspctrm            = compilation;
    group4.dimord               = 'subj_chan_freq_time';
end

% Extraction for plotting

group3_change                   = data;
if age_extraction == 1
    group3_change.powspctrm         = squeeze(nanmean(compilation(1:18,:,:,:),1));
else
    group3_change.powspctrm         = squeeze(nanmean(compilation(:,:,:,:),1));
end
group3_change.dimord            = 'chan_freq_time';
group4_change                   = data;
if age_extraction == 1
    group4_change.powspctrm         = squeeze(nanmean(compilation(19:34,:,:,:),1));
else
    group4_change.powspctrm         = squeeze(nanmean(compilation(:,:,:,:),1));
end
group4_change.dimord            = 'chan_freq_time';

%Motivated
group_change_34                    = data;
group_change_34.dimord             = 'chan_freq_time';
group_change_34.time               = group_change_34.time(extract_time_start:extract_time_end);
group_change_34.freq               = group_change_34.freq(extract_power_start:extract_power_end);
group_change_34.powspctrm          = group4_change.powspctrm - group3_change.powspctrm;

%Unmotivated versus motivated
group_change                    = group_change_34;
group_change.powspctrm          = group_change_12.powspctrm - group_change_34.powspctrm;