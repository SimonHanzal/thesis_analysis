
interest1 = nanmean(squeeze(nanmean(squeeze(nanmean(group1.powspctrm(:,33:34,25:55,101:126), 4)),2)),2);
interest2 = nanmean(squeeze(nanmean(squeeze(nanmean(group2.powspctrm(:,33:34,25:55,101:126), 4)),2)),2);

interest1_related = nanmean(squeeze(nanmean(squeeze(nanmean(group1.powspctrm(:,15:16,frequencies_related,times_related), 4)),2)),2);
interest2_related = nanmean(squeeze(nanmean(squeeze(nanmean(group2.powspctrm(:,15:16,frequencies_related,times_related), 4)),2)),2);

interest_age_1 = squeeze(nanmean(squeeze(nanmean(squeeze(nanmean(group1.powspctrm(:,17:18,:,:), 1)),1)),1));
interest_age_2 = squeeze(nanmean(squeeze(nanmean(squeeze(nanmean(group2.powspctrm(:,17:18,:,:), 1)),1)),1));

interest1 = nanmean(squeeze(nanmean(squeeze(nanmean(group1.powspctrm(:,27:28,7:19, 16:41), 4)),2)),2);
interest2 = nanmean(squeeze(nanmean(squeeze(nanmean(group2.powspctrm(:,27:28,7:19, 16:41), 4)),2)),2);

