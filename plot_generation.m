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

%% Loading in
directory = 'C:\Users\simonha\OneDrive - University of Glasgow\research\data\'
analysed_directory = strcat(directory, 'exp1_data\permutation'); 

% Path settings, do not touch!
restoredefaultpath; savepath;
addpath(fieldtrip_path);
ft_defaults;
addpath(analysed_directory)
cd(analysed_directory)

%% Settings
% Participant lists
participant_list_main =            {'10000','10001','10002','10003','10005','10007','10008','10009','10010',...%9
                               '10501','10503','10504','10505','10506','10507','10508','10509','10510',... %9
                               '15000','15001','15002','15003','15005','15006','15007','15008','15009',... %9
                               '15501','15502','15504','15505','15506','15507','15510'}; %7
               
participant_list_motivation = {'10000','10001','10003','10005','10007','10009',... %6
                               '10501','10503','10505','10507','10509',... %5
                               '15001','15005','15007','15009',... %4
                               '15501','15505','15507','15509',... %4
                               '10002','10004','10006','10008','10010',... %5
                               '10504','10506','10508','10510',... %4
                               '15000','15002',... %2
                               '15504','15506','15510'}; %3    
               
participant_list_comparison = {'10000','10001','10003','10005','10007','10009',... %6
                               '10501','10503','10505','10507','10509',... %5
                               '15001','15005','15007','15009',... %4
                               '15501','15505','15507',... %3
                               '10002','10008','10010',... %3
                               '10504','10506','10508','10510',... %4
                               '15000','15002',... %2
                               '15504','15506','15510'}; %3 
               
participant_list_motivated = { '10002','10008','10010',... %3
                               '10504','10506','10508','10510',... %4
                               '15000','15002',... %2
                               '15504','15506','15510'}; %3  

participant_list_demotivated = {'10000','10001','10003','10005','10007','10009',... %6
                               '10501','10503','10505','10507','10509',... %5
                               '15001','15005','15007','15009',... %4
                               '15501','15505','15507'}; %3    





%participant_list, group_to_load, participant_list, baseline_correct, start_time, end_time, age_extraction, end_group
project_directory = 'C:\Users\simonha\OneDrive - University of Glasgow\research\analysis\thesis_analysis';

cd(project_directory)

% Function options
dataset_options = {'_e_first','_e_last','_e_all', '_e_go_correct', '_e_nogo_correct', '_m_all'};
participant_options = {'participant_list_main','participant_list_motivation','participant_list_comparison'};
baseline_correct_options = [0,1]; %0 for no, 1 for yes
start_time_options = [1, 21];
end_time_options = [75, 151, 201];
age_extraction_options = [0,1];
end_group_options = [19, 20, 19]; %for age, motivation and comparison respectively
groups_to_compare_options = [0, 1]; %0 for between, 1 for within

% Function guide:
%[descriptive_result, test_result] = get_group_change(
%group1 = The first group to test
%group2 = The second group to test
%participant_list = The unique list of participants that can be included
%baseline_correct = Whether to correct the baseline
%start_time = The first time point in trial to consider
%end_time = The last time point in trial to consider
%age_extraction = For between groups, whether to split within
%is_second = if splitting, the second group gets different change
%end_group = If splitting, where the second between group begins
%groups_to_compare = 0 for between subject, 1 for within subject clusters
%permute_times = Permutation numbers, 20 for testing, 3000 for real
%compile = name of test to save
%analysed_directory = just pass
%project_directory = just pass
%shorten = A very special 0/1 command which shortens a 201 to 151 for
%second horup

%[group_change, test] = get_group_change(group1, group2, participant_list_main, baseline_correct, start_time, end_time, age_extraction, end_group, is_second, change_name,...
%    groups_to_compare, compile, permute_times, analysed_directory, project_directory)

% Setting test strength
x = 3000;

% 1    
[group_change, test] = get_group_change('_e_first','_e_last',participant_list_main, 1, 1, 151, 0, 19, 0, 'task_change',...
    1, x, 'task_change_test', analysed_directory, project_directory, 0);
% 2
[group_change, test] = get_group_change('_e_last','_e_first',participant_list_main, 1, 1, 151, 0, 19, 0, 'task_change_reversed',...
    1, x, 'task_change_reversed_test', analysed_directory, project_directory, 0);
% 3
% task_change_age | e_last - e_first difference young x e_last - e_first difference older

% 4
[group_change, test] = get_group_change('_e_all','_e_all',participant_list_main, 1, 1, 151, 1, 19, 1, 'task_age_all',...
    0, x, 'task_age_all_test', analysed_directory, project_directory, 0);
% 5
[group_change, test] = get_group_change('_e_go_correct','_e_go_correct',participant_list_main, 1, 1, 151, 1, 19, 1, 'task_age_go',...
    0, x, 'task_age_go_test', analysed_directory, project_directory, 0);
% 6
[group_change, test] = get_group_change('_e_nogo_correct','_e_nogo_correct',participant_list_main, 1, 1, 151, 1, 19, 1, 'task_age_nogo',...
    0, x, 'task_age_nogo_test', analysed_directory, project_directory, 0);
% 7
[group_change, test] = get_group_change('_m_all','_m_all',participant_list_motivation, 1, 1, 201, 1, 20, 1, 'task_motivation_9',...
    0, x, 'task_motivation_9_test', analysed_directory, project_directory, 0);
% 8
[group_change, test] = get_group_change('_m_all','_e_last',participant_list_motivated, 1, 1, 201, 1, 10, 1, 'task_motivated_89',...
    0, x, 'task_motivated_89_test', analysed_directory, project_directory, 1);
% 9
[group_change, test] = get_group_change('_m_all','_e_last',participant_list_motivated, 1, 1, 201, 1, 12, 1, 'task_motivated_89',...
    0, x, 'task_demotivated_89_test', analysed_directory, project_directory, 1);
% 10
% task_age_89 | m_all motivation difference young x e_last motivation difference older

% 11    
[group_change, test] = get_group_change('_e_all','_e_all',participant_list_main, 0, 21, 75, 1, 19, 1, 'window_age_all',...
    0, x, 'window_age_all_test', analysed_directory, project_directory, 0);
% 12
[group_change, test] = get_group_change('_e_first','_e_last',participant_list_main, 0, 21, 75, 0, 19, 0, 'window_change',...
    1, x, 'window_change_test', analysed_directory, project_directory, 0);
% 13
[group_change, test] = get_group_change('_e_last','_e_first',participant_list_main, 0, 21, 75, 0, 19, 0, 'window_change_reversed',...
    1, x, 'window_change_reversed_test', analysed_directory, project_directory, 0);
% 14
%window_change_age e_last x e_first difference young | e_last x e_first difference older

% 15
[group_change, test] = get_group_change('_m_all','_m_all',participant_list_motivation, 0, 21, ??, 1, 20, 1, 'window_motivation_9',...
    0, x, 'window_motivation_9_test', analysed_directory, project_directory, 0);
% 16
[group_change, test] = get_group_change('_m_all','_e_last',participant_list_motivated, 0, 21, ??, 1, 12, 1, 'window_motivated_89',...
    0, x, 'window_motivated_89_test', analysed_directory, project_directory, 1);
% 17
[group_change, test] = get_group_change('_m_all','_e_last',participant_list_demotivated, 0, 21, ??, 1, 12, 1, 'window_demotivated_89',...
    0, x, 'window_demotivated_89_test', analysed_directory, project_directory, 1);
% 18
%window_age_89 m_all motivation difference young x e_last motivation difference older
