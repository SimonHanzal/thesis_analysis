%% Identify top electrodes
load(strcat(test_name, '_test.mat'))

extraction = squeeze(nanmean(squeeze(nanmean(test.stat,3)),2));
top_2_electrodes = mink(extraction,2);
index_1 = find(extraction == top_2_electrodes(1));
index_2 = find(extraction == top_2_electrodes(2));
test.label(index_1)
test.label(index_2)
% For uncorrected
%P5, P7

% For Corrected
%C3, FC6

%% Extract
load(strcat(test_name, '.mat'))

% alpha main
test_name = 'tot_uncorrected'
test_name = 'tot_uncorrected_young_e_first';
test_name = 'tot_uncorrected_young_e_last';
test_name = 'tot_uncorrected_older_e_first';
test_name = 'tot_uncorrected_older_e_last';

% alpha motivation
test_name = 'betwee_motivation_young_e_last';
test_name = 'between_motivation_older_e_last';
test_name = 'betwee_motivation_young_ms_all';
test_name = 'between_motivation_older_ms_all';

% alpha demotivation
test_name = 'between_demotivation_young_e_last';
test_name = 'between_demotivation_older_e_last';
test_name = 'between_demotivation_young_ms_all';
test_name = 'between_demotivation_older_ms_all';


% Values for drift
interest1 = nanmean(squeeze(nanmean(squeeze(nanmean(group.powspctrm(:,[15 49],7:19,:), 4)),2)),2);
interest2 = nanmean(squeeze(nanmean(squeeze(nanmean(group.powspctrm(:,[15 49],7:19,:), 4)),2)),2);

%Beta main
test_name = 'tot_reversed'
test_name = 'tot_young_reversed_e_first';
test_name = 'tot_young_reversed_e_last';
test_name = 'tot_older_reversed_e_first';
test_name = 'tot_older_reversed_e_last';

% beta motivation
test_name = 'between_motivation_corrected_young_e_last';
test_name = 'between_motivation_corrected_older_e_last';
test_name = 'between_motivation_corrected_young_ms_all';
test_name = 'between_motivation_corrected_older_ms_all';

% beta demotivation
test_name = 'between_demotivation_corrected_young_e_last';
test_name = 'between_demotivation_corrected_older_e_last';
test_name = 'between_demotivation_corrected_young_ms_all';
test_name = 'between_demotivation_corrected_older_ms_all';



% Values for task
interest1 = nanmean(squeeze(nanmean(squeeze(nanmean(group.powspctrm(:,[5 26],25:55,101:126), 4)),2)),2);
interest2 = nanmean(squeeze(nanmean(squeeze(nanmean(group.powspctrm(:,[5 26],25:55,101:126), 4)),2)),2);



interest2 = nanmean(squeeze(nanmean(squeeze(nanmean(group2.powspctrm(:,33:34,25:55,101:126), 4)),2)),2);

interest1_related = nanmean(squeeze(nanmean(squeeze(nanmean(group1.powspctrm(:,15:16,frequencies_related,times_related), 4)),2)),2);
interest2_related = nanmean(squeeze(nanmean(squeeze(nanmean(group2.powspctrm(:,15:16,frequencies_related,times_related), 4)),2)),2);

interest_age_1 = squeeze(nanmean(squeeze(nanmean(squeeze(nanmean(group1.powspctrm(:,17:18,:,:), 1)),1)),1));
interest_age_2 = squeeze(nanmean(squeeze(nanmean(squeeze(nanmean(group2.powspctrm(:,17:18,:,:), 1)),1)),1));

interest1 = nanmean(squeeze(nanmean(squeeze(nanmean(group1.powspctrm(:,27:28,7:19, 16:41), 4)),2)),2);
interest2 = nanmean(squeeze(nanmean(squeeze(nanmean(group2.powspctrm(:,27:28,7:19, 16:41), 4)),2)),2);

