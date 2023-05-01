%% Add-ons
clear all

% EEG processing packages
fieldtrip_path = 'C:\Users\simonha\AppData\Roaming\MathWorks\MATLAB Add-Ons\Collections\FieldTrip';
% channel locations
chanloc_path = 'C:\Users\simonha\AppData\Roaming\MathWorks\MATLAB Add-Ons\Collections\EEGLAB\plugins\dipfit4.3\standard_BEM\elec\standard_1005.elc';
% Viridis
viridis_path = ('C:\Users\simonha\AppData\Roaming\MathWorks\MATLAB Add-Ons\Collections\cbrewer _ colorbrewer schemes for Matlab\cbrewer\cbrewer');

% adding to path
addpath(fieldtrip_path, viridis_path)

%% Directory
directory = 'C:\Users\simonha\OneDrive - University of Glasgow\research\data\'
analysed_directory = strcat(directory, 'exp1_data\permutation'); 

% Path settings, do not touch!
restoredefaultpath; savepath;
addpath(fieldtrip_path);
ft_defaults;
addpath(analysed_directory)
cd(analysed_directory)
project_directory = 'C:\Users\simonha\OneDrive - University of Glasgow\research\analysis\thesis_analysis';
addpath(project_directory)

%% Participant lists
participant_list_main =        {'10000','10001','10002','10003','10005','10007','10008','10009','10010',...%9
                               '10501','10503','10504','10505','10506','10507','10508','10509','10510',... %9
                               '15000','15001','15002','15003','15005','15006','15007','15008','15009',... %9
                               '15501','15502','15504','15505','15506','15507','15510'}; %7
                           
participant_list_main_older =  {'15000','15001','15002','15003','15005','15006','15007','15008','15009',... %9
                               '15501','15502','15504','15505','15506','15507','15510'}; %7
                           
participant_list_main_young =  {'10000','10001','10002','10003','10005','10007','10008','10009','10010',...%9
                               '10501','10503','10504','10505','10506','10507','10508','10509','10510'}; %7
                           
               
participant_list_motivation =  {'10000','10001','10003','10005','10007','10009',... %6
                               '10501','10503','10505','10507','10509',... %5
                               '15001','15005','15007','15009',... %4
                               '15501','15505','15507','15509',... %4
                               '10002','10004','10006','10008','10010',... %5
                               '10504','10506','10508','10510',... %4
                               '15000','15002',... %2
                               '15504','15506','15510'}; %3
                           
participant_list_motivation_reversed = {'10002','10004','10006','10008','10010',... %5
                               '10504','10506','10508','10510',... %4
                               '15000','15002',... %2
                               '15504','15506','15510',... %3 
                                '10000','10001','10003','10005','10007','10009',... %6
                               '10501','10503','10505','10507','10509',... %5
                               '15001','15005','15007','15009',... %4
                               '15501','15505','15507','15509'}%4; 
               
participant_list_comparison =  {'10000','10001','10003','10005','10007','10009',... %6
                               '10501','10503','10505','10507','10509',... %5
                               '15001','15005','15007','15009',... %4
                               '15501','15505','15507',... %3
                               '10002','10008','10010',... %3
                               '10504','10506','10508','10510',... %4
                               '15000','15002',... %2
                               '15504','15506','15510'}; %3 
               
participant_list_motivated =   {'10002','10008','10010',... %3
                               '10504','10506','10508','10510',... %4
                               '15000','15002',... %2
                               '15504','15506','15510'}; %3
                           
participant_list_motivated_young = { '10002','10008','10010',... %3
                                     '10504','10506','10508','10510'}; %3
 
participant_list_motivated_older = {'15000','15002',... %2
                                    '15504','15506','15510'}; %3  

participant_list_demotivated = {'10000','10001','10003','10005','10007','10009',... %6
                               '10501','10503','10505','10507','10509',... %5
                               '15001','15005','15007','15009',... %4
                               '15501','15505','15507'}; %3

participant_list_demotivated_young = {'10000','10001','10003','10005','10007','10009',... %6
                               '10501','10503','10505','10507','10509'}; %3    
                           
participant_list_demotivated_older = {'15001','15005','15007','15009',... %4
                               '15501','15505','15507'}; %3    

%% Function guide:
% [descriptive_result, test_result] = get_group_change(
% group1 = The first group to test
% group2 = The second group to test
% subtracted_name = Name of dataset to subtract, if not subtracting, 0
% participant_list = The unique list of participants that can be included
% baseline_correct = Whether to correct the baseline
% start_time = The first time point in trial to consider
% end_time = The last time point in trial to consider
% split = For between groups, whether to split within the list
% second_group_position = If splitting, where the second between group begins
% groups_to_compare = 0 for between subject, 1 for within subject clusters
% permute_times = Permutation numbers, 20 for testing, 3000 for real
% shorten = A very special (0,1) command which shortens a 201 timepoint dataset to 151, a workaround of a previous difficulty
% subtracted = When permuting a 2x2, whether to reduce by subtraction alongside a dimension 
% change_name = Name of the outputs


%% Function guide options
% dataset_options = {'_e_first','_e_last','_e_all', '_e_go_correct', '_e_nogo_correct', '_ms_all'};
% participant_options = {'participant_list_main','participant_list_motivation','participant_list_comparison'};
% baseline_correct_options = [0,1]; %0 for no, 1 for yes
% start_time_options = [1, 21];
% end_time_options = [75, 151, 201];
% age_extraction_options = [0,1];
% second_group_position_options = [19, 20, 19]; %for age, motivation and comparison respectively
% groups_to_compare_options = [0, 1]; %0 for between, 1 for within

% Parameter list
%function [group_change, test] = get_group_change(
%project_directory, analysed_directory, group1, group2, subtracted_name,
%participant_list, baseline_correct, start_time, end_time, split
%second_group_position, groups_to_compare, permute_times, shorten,  change_name)

% Setting test strength
x = 3000;

%% Tests
[group_change, test] = get_group_change(...
    project_directory,... % project directory
    analysed_directory,... % analysed directory
    '_ms_all',... % group1
    '_ms_all',... % group2
    0,... % subtracted_name
    participant_list_motivation,... % participant_list
    0,...   % baseline_correct
    21,... % start_time
    75,... % end_time 
    1,... % split
    20,... % second_group_position
    0,... % groups_to_compare
    x,... % permute_times 
    0,... % shorten
    'within_motivation') % change_name


%% TOT uncorrected
[group_change, test] = get_group_change(...
    project_directory,... % project directory
    analysed_directory,... % analysed directory
    '_e_last',... % group1
    '_e_first',... % group2
    0,... % subtracted_name
    participant_list_main,... % participant_list
    0,...   % baseline_correct
    21,... % start_time
    75,... % end_time 
    0,... % split
    19,... % second_group_position
    1,... % groups_to_compare
    x,... % permute_times 
    0,... % shorten
    'tot_uncorrected') % change_name

%% TOT uncorrected reversed
[group_change, test] = get_group_change(...
    project_directory,... % project directory
    analysed_directory,... % analysed directory
    '_e_first',... % group1
    '_e_last',... % group2
    0,... % subtracted_name
    participant_list_main_young,... % participant_list
    0,...   % baseline_correct
    21,... % start_time
    75,... % end_time 
    0,... % split
    19,... % second_group_position
    1,... % groups_to_compare
    x,... % permute_times 
    0,... % shorten
    'tot_uncorrected_reversed') % change_name

%% TOT uncorrected older 4+6
[group_change, test] = get_group_change(...
    project_directory,... % project directory
    analysed_directory,... % analysed directory
    '_e_last',... % group1
    '_e_first',... % group2
    0,... % subtracted_name
    participant_list_main_older,... % participant_list
    0,...   % baseline_correct
    21,... % start_time
    75,... % end_time 
    0,... % split
    19,... % second_group_position
    1,... % groups_to_compare
    x,... % permute_times 
    0,... % shorten
    'tot_uncorrected_older') % change_name

%% TOT uncorrected older 4+6 reversed
[group_change, test] = get_group_change(...
    project_directory,... % project directory
    analysed_directory,... % analysed directory
    '_e_first',... % group1
    '_e_last',... % group2
    0,... % subtracted_name
    participant_list_main_older,... % participant_list
    0,...   % baseline_correct
    21,... % start_time
    75,... % end_time 
    0,... % split
    19,... % second_group_position
    1,... % groups_to_compare
    x,... % permute_times 
    0,... % shorten
    'tot_uncorrected_older_reversed') % change_name

%% TOT uncorrected young 4+6
[group_change, test] = get_group_change(...
    project_directory,... % project directory
    analysed_directory,... % analysed directory
    '_e_last',... % group1
    '_e_first',... % group2
    0,... % subtracted_name
    participant_list_main_young,... % participant_list
    0,...   % baseline_correct
    21,... % start_time
    75,... % end_time 
    0,... % split
    19,... % second_group_position
    1,... % groups_to_compare
    x,... % permute_times 
    0,... % shorten
    'tot_uncorrected_young') % change_name

%% TOT uncorrected young 4+6 reversed
[group_change, test] = get_group_change(...
    project_directory,... % project directory
    analysed_directory,... % analysed directory
    '_e_first',... % group1
    '_e_last',... % group2
    0,... % subtracted_name
    participant_list_main_young,... % participant_list
    0,...   % baseline_correct
    21,... % start_time
    75,... % end_time 
    0,... % split
    19,... % second_group_position
    1,... % groups_to_compare
    x,... % permute_times 
    0,... % shorten
    'tot_uncorrected_young_reversed') % change_name

%% 8 Between motivation young
[group_change, test] = get_group_change(...
    project_directory,... % project directory
    analysed_directory,... % analysed directory
    '_ms_all',... % group1
    '_e_last',... % group2
    0,... % subtracted_name
    participant_list_demotivated_young,... % participant_list
    0,...   % baseline_correct
    21,... % start_time
    75,... % end_time 
    0,... % split
    19,... % second_group_position
    1,... % groups_to_compare
    x,... % permute_times 
    0,... % shorten
    'between_demotivation_young') % change_name

%% 8 Between motivation older
[group_change, test] = get_group_change(...
    project_directory,... % project directory
    analysed_directory,... % analysed directory
    '_ms_all',... % group1
    '_e_last',... % group2
    0,... % subtracted_name
    participant_list_demotivated_older,... % participant_list
    0,...   % baseline_correct
    21,... % start_time
    75,... % end_time 
    0,... % split
    19,... % second_group_position
    1,... % groups_to_compare
    x,... % permute_times 
    0,... % shorten
    'between_demotivation_older') % change_name

%% 8 Between motivation corrected young
[group_change, test] = get_group_change(...
    project_directory,... % project directory
    analysed_directory,... % analysed directory
    '_ms_all',... % group1
    '_e_last',... % group2
    0,... % subtracted_name
    participant_list_demotivated_young,... % participant_list
    1,...   % baseline_correct
    1,... % start_time
    151,... % end_time 
    0,... % split
    19,... % second_group_position
    1,... % groups_to_compare
    x,... % permute_times 
    0,... % shorten
    'between_demotivation_corrected_young') % change_name

%% 8 Between motivation corrected older
[group_change, test] = get_group_change(...
    project_directory,... % project directory
    analysed_directory,... % analysed directory
    '_ms_all',... % group1
    '_e_last',... % group2
    0,... % subtracted_name
    participant_list_demotivated_older,... % participant_list
    1,...   % baseline_correct
    1,... % start_time
    151,... % end_time 
    0,... % split
    19,... % second_group_position
    1,... % groups_to_compare
    x,... % permute_times 
    0,... % shorten
    'between_demotivation_corrected_older') % change_name

%% 9 + 12 tot
[group_change, test] = get_group_change(...
    project_directory,... % project directory
    analysed_directory,... % analysed directory
    '_e_last',... % group1
    '_e_first',... % group2
    0,... % subtracted_name
    participant_list_main,... % participant_list
    1,...   % baseline_correct
    1,... % start_time
    151,... % end_time 
    0,... % split
    19,... % second_group_position
    1,... % groups_to_compare
    x,... % permute_times 
    0,... % shorten
    'tot') % change_name

%% 9 + 12 tot reversed
[group_change, test] = get_group_change(...
    project_directory,... % project directory
    analysed_directory,... % analysed directory
    '_e_first',... % group1
    '_e_last',... % group2
    0,... % subtracted_name
    participant_list_main,... % participant_list
    1,...   % baseline_correct
    1,... % start_time
    151,... % end_time 
    0,... % split
    19,... % second_group_position
    1,... % groups_to_compare
    x,... % permute_times 
    0,... % shorten
    'tot_reversed') % change_name

%% 10 tot older
[group_change, test] = get_group_change(...
    project_directory,... % project directory
    analysed_directory,... % analysed directory
    '_e_last',... % group1
    '_e_first',... % group2
    0,... % subtracted_name
    participant_list_main_older,... % participant_list
    1,...   % baseline_correct
    1,... % start_time
    151,... % end_time 
    0,... % split
    19,... % second_group_position
    1,... % groups_to_compare
    x,... % permute_times 
    0,... % shorten
    'tot_older') % change_name

%% 10 tot young reversed
[group_change, test] = get_group_change(...
    project_directory,... % project directory
    analysed_directory,... % analysed directory
    '_e_first',... % group1
    '_e_last',... % group2
    0,... % subtracted_name
    participant_list_main_young,... % participant_list
    1,...   % baseline_correct
    1,... % start_time
    151,... % end_time 
    0,... % split
    19,... % second_group_position
    1,... % groups_to_compare
    x,... % permute_times 
    0,... % shorten
    'tot_young_reversed') % change_name

%% 10 tot older reversed
[group_change, test] = get_group_change(...
    project_directory,... % project directory
    analysed_directory,... % analysed directory
    '_e_first',... % group1
    '_e_last',... % group2
    0,... % subtracted_name
    participant_list_main_older,... % participant_list
    1,...   % baseline_correct
    1,... % start_time
    151,... % end_time 
    0,... % split
    19,... % second_group_position
    1,... % groups_to_compare
    x,... % permute_times 
    0,... % shorten
    'tot_older_reversed') % change_name

%% 11 tot young
[group_change, test] = get_group_change(...
    project_directory,... % project directory
    analysed_directory,... % analysed directory
    '_e_last',... % group1
    '_e_first',... % group2
    0,... % subtracted_name
    participant_list_main_young,... % participant_list
    1,...   % baseline_correct
    1,... % start_time
    151,... % end_time 
    0,... % split
    19,... % second_group_position
    1,... % groups_to_compare
    x,... % permute_times 
    0,... % shorten
    'tot_young') % change_name

%% 11 tot young reversed
[group_change, test] = get_group_change(...
    project_directory,... % project directory
    analysed_directory,... % analysed directory
    '_e_first',... % group1
    '_e_last',... % group2
    0,... % subtracted_name
    participant_list_main_young,... % participant_list
    1,...   % baseline_correct
    1,... % start_time
    151,... % end_time 
    0,... % split
    19,... % second_group_position
    1,... % groups_to_compare
    x,... % permute_times 
    0,... % shorten
    'tot_young_reversed') % change_name

%% Age effects in trial types test nogo

[group_change, test] = get_group_change(...
    project_directory,... % project directory
    analysed_directory,... % analysed directory
    '_e_nogo_correct',... % group1
    '_e_nogo_correct',... % group2
    0,... % subtracted_name
    participant_list_main,... % participant_list
    1,...   % baseline_correct
    1,... % start_time
    201,... % end_time 
    1,... % split
    19,... % second_group_position
    0,... % groups_to_compare
    x,... % permute_times 
    0,... % shorten
    'nogo_test') % change_name

% Somethign wrong with go trials, using e_go seems to work better. Can
% check later.

%% Age effects in trial types test go

[group_change, test] = get_group_change(...
    project_directory,... % project directory
    analysed_directory,... % analysed directory
    '_e_go',... % group1
    '_e_go',... % group2
    0,... % subtracted_name
    participant_list_main,... % participant_list
    1,...   % baseline_correct
    1,... % start_time
    151,... % end_time 
    1,... % split
    19,... % second_group_position
    0,... % groups_to_compare
    x,... % permute_times 
    0,... % shorten
    'go_test') % change_name


%% Within motivation splitting test

[group_change, test] = get_group_change(...
    project_directory,... % project directory
    analysed_directory,... % analysed directory
    '_ms_all',... % group1
    '_ms_all',... % group2
    0,... % subtracted_name
    participant_list_motivation,... % participant_list
    1,...   % baseline_correct
    1,... % start_time
    151,... % end_time 
    1,... % split
    20,... % second_group_position
    0,... % groups_to_compare
    x,... % permute_times 
    0,... % shorten
    'within_motivation_test') % change_name

%% Age differences
[group_change, test] = get_group_change(...
    project_directory,... % project directory
    analysed_directory,... % analysed directory
    '_e_last',... % group1
    '_e_last',... % group2
    '_e_first',... % subtracted_name
    participant_list_main,... % participant_list
    1,...   % baseline_correct
    1,... % start_time
    151,... % end_time 
    1,... % split
    19,... % second_group_position
    0,... % groups_to_compare
    x,... % permute_times 
    0,... % shorten
    'age_differences') % change_name