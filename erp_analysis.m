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

plot(times,erp_difference)
xline(0)
yline(0)

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

erp_difference = erp_extraction_late - erp_extraction_early;

plot(times,erp_difference)
xline(0)
yline(0)