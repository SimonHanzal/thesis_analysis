%% Extraction

% Specifying electrodes

% Curve information
curve_young = squeeze(nanmean(squeeze(nanmean(squeeze(nanmean(group1.powspctrm(:,:,25:55,:),1)),1)),1));
curve_older = squeeze(nanmean(squeeze(nanmean(squeeze(nanmean(group2.powspctrm(:,:,25:55,:),1)),1)),1));

curve_test = curve_older*1.05;

csvwrite('curve_young.csv',curve_young)
csvwrite('curve_older.csv',curve_older)



% Baseline correction

curve_young = curve_young - nanmean(curve_young(1:75));
curve_older = curve_older - nanmean(curve_older(1:75));

% Plot

times = single(group1.time);

plot(times,curve_young, 'r')
hold on
plot(times,curve_older, 'b')
xline(0)

% Permutest

[clusters, p_values, t_sums, permutation_distribution] = permutest(curve_young(9:194), curve_older(9:194), false, 0.05, 10000, true);

% Permutest only in the important segment
[clusters, p_values, t_sums, permutation_distribution] = permutest(curve_young(116:141), curve_older(116:141), false, 0.05, 10000, true);
% Very distinguishable