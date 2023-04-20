
%15, 16,, 5,6,, 59,60 
%Extraction for ROI tests
interest1 = nanmean(squeeze(nanmean(squeeze(nanmean(group1.powspctrm(:,59:60,12:24,86:101), 4)),2)),2);
interest2 = nanmean(squeeze(nanmean(squeeze(nanmean(group2.powspctrm(:,59:60,12:24,86:101), 4)),2)),2);

interest1_related = nanmean(squeeze(nanmean(squeeze(nanmean(group1.powspctrm(:,15:16,frequencies_related,times_related), 4)),2)),2);
interest2_related = nanmean(squeeze(nanmean(squeeze(nanmean(group2.powspctrm(:,15:16,frequencies_related,times_related), 4)),2)),2);

interest_age_1 = squeeze(nanmean(squeeze(nanmean(squeeze(nanmean(group1.powspctrm(:,17:18,:,:), 1)),1)),1));
interest_age_2 = squeeze(nanmean(squeeze(nanmean(squeeze(nanmean(group2.powspctrm(:,17:18,:,:), 1)),1)),1));

times = single(data.time);

plot(times,interest_age_1, 'r')
hold on
plot(times,interest_age_2, 'b')
xline(0)
