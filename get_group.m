function [group, group_change] = get_group(group_to_load, participant_list, baseline_correct, start_time, end_time, age_extraction, end_group, is_second, name, change_name, shorten)

    baseline_start = -1.2;
    baseline_end = -.7;
    baseline_type = 'relative';
    subtracted_dataset = 0; %or name of dataset
    subtracted_dataset_name = 'last';
    
    decibels = 0; %0 not to transform

    participants  = length(participant_list);
    channel_list = [1:32 33:64];%64
    channel_no = length(channel_list);
    dimord_setting = 'chan_freq_time';
    extract_power_start = 13;
    extract_power_end = 115;%115;
    extract_time_start = start_time; %21
    extract_time_end = end_time; %75
    if end_time == 201 && shorten == 1
        extract_time_addition = 24;
        extract_time_subtraction = -26;
    else
        extract_time_addition = 0;
        extract_time_subtraction = 0;
    end 
    frequencies = extract_power_end - extract_power_start + 1;
    timepoints = extract_time_end - extract_time_start + 1 - extract_time_addition + extract_time_subtraction;
    compilation = zeros(participants, channel_no, frequencies, timepoints);

    i = 1;
    for i = 1:length(participant_list)
        i
        load(char(strcat(participant_list(i), group_to_load, '.mat')))
        data.dimord = dimord_setting;
        if baseline_correct == 1
            cfg = [];
            cfg.baseline = [baseline_start baseline_end];
            cfg.baselinetype = baseline_type;
            data = ft_freqbaseline(cfg, data);
        end
        dataset1 = data.powspctrm(channel_list,extract_power_start:extract_power_end,extract_time_start+extract_time_addition:extract_time_end+extract_time_subtraction);
        if subtracted_dataset == 0
        else
            load(char(strcat(participant_list(i), subtracted_dataset_name, '.mat')))
            data.dimord = dimord_setting;
            if baseline_correct == 1
                cfg = [];
                cfg.baseline = [baseline_start baseline_end];
                cfg.baselinetype = baseline_type;
                data = ft_freqbaseline(cfg, data);
            end
            dataset2 = data.powspctrm(channel_list,extract_power_start:extract_power_end,extract_time_start+extract_time_addition:extract_time_end+extract_time_subtraction);
        end
        if subtracted_dataset == 0
            if decibels == 0
                compilation(i,:,:,:) = dataset1;
            else
                compilation(i,:,:,:) = db(dataset1);
            end
        else
            if decibels == 0
                compilation(i,:,:,:) = dataset1 - dataset2;
            else
                compilation(i,:,:,:) = db(dataset1) - db(dataset2);
            end
        end
    end
    group = data;
    group.time = group.time(extract_time_start:extract_time_end);
    group.freq = group.freq(extract_power_start:extract_power_end);
    if age_extraction == 1
        if is_second == 1
            group.powspctrm = compilation(1:end_group-1,:,:,:);
        else
            group.powspctrm = compilation(end_group:length(participant_list),:,:,:);
        end
        group.dimord = 'subj_chan_freq_time';
    else
        group.powspctrm = compilation;
        group.dimord = 'subj_chan_freq_time';
    end
    group_change = data;
    if age_extraction == 1
        if is_second == 1
            group_change.powspctrm = squeeze(nanmean(compilation(end_group:length(participant_list),:,:,:),1));
        else
            group_change.powspctrm = squeeze(nanmean(compilation(1:end_group-1,:,:,:),1));
        end

    else
        group_change.powspctrm = squeeze(nanmean(compilation(:,:,:,:),1));
    end
    group_change.dimord = 'chan_freq_time';
    save(strcat('clusters/', change_name, name,'.mat'), 'group', '-v7.3')
end