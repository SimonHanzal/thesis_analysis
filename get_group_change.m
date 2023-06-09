function [group_change, test] = get_group_change(project_directory, analysed_directory, group1, group2, subtracted_name, participant_list, baseline_correct, start_time, end_time, split, second_group_position, ...
    groups_to_compare, permute_times, shorten, change_name)
    
    compile = strcat(change_name, '_test')
    if isequal(subtracted_name,0)
        subtracted = 0
    else
        subtracted = 1
    end
    if split == 1
        group_1_is_second = 0;
        group_2_is_second = 1;
    else
        group_1_is_second = 0;
        group_2_is_second = 0;
    end
    if shorten == 1
        end_time_1 = end_time;
        end_time_2 = end_time-50;
    else
        end_time_1 = end_time;
        end_time_2 = end_time;
    end
    cd(project_directory)
    [group_1, group_1_change] = get_group(project_directory, analysed_directory, group1, subtracted_name, participant_list, baseline_correct, start_time, end_time_1, split, second_group_position, group_1_is_second, group1, shorten, subtracted, change_name);
    [group_2, group_2_change] = get_group(project_directory, analysed_directory, group2, subtracted_name, participant_list, baseline_correct, start_time, end_time_2, split, second_group_position, group_2_is_second, group2, shorten, subtracted, change_name);
    % Group difference calculation
    group_change = group_1;
    group_change.dimord = 'chan_freq_time';
    group_change.powspctrm = group_2_change.powspctrm - group_1_change.powspctrm;
    save(strcat('clusters/',change_name,'.mat'), 'group_change', '-v7.3')
   
    
    foi_contrast = [4 40];

    % Load neighbours
    cd('C:\Users\simonha\OneDrive - University of Glasgow\research\analysis\archive\learning_clusters\tutorial2');
    load('easycap64ch-avg_neighb.mat', 'neighbours');
    cd(analysed_directory)
    cfg = [];
    cfg.output = 'pow';
    cfg.channel = {'EEG', '-EOG', '-ECG'};
    cfg.avgovergchan = 'no';
    cfg.frequency = foi_contrast;
    cfg.avgovergfreq = 'yes';
    cfg.parameter = 'powspctrm';
    cfg.correctm = 'cluster'
    cfg.clusteralpha = 0.05;                        
    cfg.clusterthreshold = 'nonparametric_common';
    cfg.minnbchan = 2;                           
    cfg.tail = 0;                           
    cfg.clustertail = cfg.tail;
    cfg.alpha = 0.05;                        
    cfg.correcttail = 'alpha';                     
    cfg.computeprob = 'yes';
    cfg.numrandomization = permute_times;                         
    cfg.neighbours = neighbours;
    cfg.method = 'distance';
    cfg.neighbours = ft_prepare_neighbours(cfg, group_1);
    cfg.method = 'ft_statistics_montecarlo';
    cfg.ivar = 1;

    if groups_to_compare == 0 %between
        cfg.statistic = 'ft_statfun_indepsamplesT';
        cfg.clusterstatistic = 'maxsum';
        size1 = size(group_1.powspctrm,1);
        size2 = size(group_2.powspctrm,1);
        design = zeros(1,size1 + size2); 
        design(1,1:size1) = 1;
        design(1,size1+1:(size1+size2)) = 2;
        design(2,:) = [1:length(participant_list)];   
    elseif groups_to_compare == 1 %within
        cfg.statistic = 'ft_statfun_depsamplesT';
        cfg.clusterstatistic = 'maxsize';
        size1 = size(group_1.powspctrm,1);
        size2 = size(group_2.powspctrm,1);
        design = zeros(1, size1 + size2); %second here
        design(1,1:size1) = 1;
        design(1,(size1+1):(size1 + size2)) = 2; %second here
        design(2,:) = [1:length(participant_list) 1:length(participant_list)];
        cfg.uvar = 1;
    end

    cfg.design = design;

    test = ft_freqstatistics(cfg, group_1, group_2);
    cd(project_directory)
    save(strcat('clusters\', compile,'.mat'), 'test', '-v7.3')     
end