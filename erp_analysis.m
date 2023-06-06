%Last
erp_alpha_comparison = zeros(4000,0);
erp_alpha_early_baselined = zeros(4000,0);
erp_alpha_late_baselined = zeros(4000,0);

for i = 1:34
    erp_alpha_early_baselined(:,i) = erp_alpha_early(:,i) - squeeze(mean(erp_alpha_early(1:2000,i),1));
    erp_alpha_late_baselined(:,i) = erp_alpha(:,i) - squeeze(mean(erp_alpha(1:2000,i),1));
end



times = single(EEG.times);
erp_extraction_early = squeeze(mean(erp_alpha_early_baselined,2));
erp_extraction_late = squeeze(mean(erp_alpha_late_baselined,2));

erp_difference = erp_extraction_late - erp_extraction_early;

plot(times,erp_extraction_early, 'blue','LineWidth',1.5)
hold on
plot(times,erp_extraction_late, 'red','LineWidth',1.5)
xline(0)
yline(0)
legend({'First Block', 'Last Block'},'FontSize',14)
xticks(-100:100:1400)
xlim([-200 1400])
set(gcf,'color','w');
xlabel('Time','FontSize',18)

%Taking 2280ms values for ANOVAs

anova(1,:) = erp_alpha_early(2280,:);
anova(2,:) = erp_alpha(2280,:);
anova_export = anova';
cd('C:\Users\simonha\OneDrive - University of Glasgow\research\analysis\behaviour\behavioural_analysis\data')
csvwrite('erp_confirmation.csv',anova_export)

%Eye
erp_eye_comparison = zeros(4000,0);
erp_eye_early_baselined = zeros(4000,0);
erp_eye_late_baselined = zeros(4000,0);



for i = 1:34
    erp_eye_early_baselined(:,i) = erp_eye_early(:,i) - squeeze(mean(erp_eye_early(1:2000,i),1));
    erp_eye_late_baselined(:,i) = erp_eye_late(:,i) - squeeze(mean(erp_eye_late(1:2000,i),1));
end



times = single(EEG.times);
erp_extraction_early = squeeze(mean(erp_eye_early,2));
erp_extraction_late = squeeze(mean(erp_eye_late,2));

anova(1,:) = erp_eye_early(2500,:);
anova(2,:) = erp_eye_late(2500,:);
anova_export = anova';
cd('C:\Users\simonha\OneDrive - University of Glasgow\research\analysis\behaviour\behavioural_analysis\data')
csvwrite('erp_eye_confirmation.csv',anova_export)

erp_difference = erp_extraction_late - erp_extraction_early;

plot(times,erp_difference)
xline(0)
yline(0)