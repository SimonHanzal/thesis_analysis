
%% Add-ons
clear all

% EEG processing packages
fieldtrip_path = 'C:\Users\simonha\AppData\Roaming\MathWorks\MATLAB Add-Ons\Collections\FieldTrip';
eeglab_path = 'C:\Users\simonha\AppData\Roaming\MathWorks\MATLAB Add-Ons\Collections\EEGLAB';
% channel locations
chanloc_path = 'C:\Users\simonha\AppData\Roaming\MathWorks\MATLAB Add-Ons\Collections\EEGLAB\plugins\dipfit4.3\standard_BEM\elec\standard_1005.elc';
load('channel_locations.mat')
% Viridis
viridis_path = ('C:\Users\simonha\AppData\Roaming\MathWorks\MATLAB Add-Ons\Collections\MatPlotLib Perceptually Uniform Colormaps');

% adding to path
addpath(eeglab_path, fieldtrip_path, viridis_path)

%% Loading in
directory = 'C:\Users\simonha\OneDrive - University of Glasgow\research\data\'
analysed_directory = strcat(directory, 'exp1_data\permutation'); 

% Path settings, do not touch!
restoredefaultpath; savepath;
addpath(fieldtrip_path);
ft_defaults;
addpath(analysed_directory)
cd(analysed_directory)

test_name = '_e_prestimulus';
load(strcat('describe', test_name, '.mat'))
load(strcat('test', test_name, '.mat'))

%% Spectrogram

% Style
addpath(viridis_path)
load('channel_locations.mat')
[cMap] = viridis(512);
cMap = flipud(cMap);
%load(strcat(cluster_name,'.mat'))

freq_interp = linspace(5, 40, 512);

%channel_plot = {'FPz','FZ','F1','F2','F3','F4','AFz','AF3','AF4'}; %frontal
%channel_plot = {'Pz', 'P1', 'P2', 'P3', 'P4', 'P5', 'P6', 'PO3', 'PO4'}; %parietal
%channel_plot = {'O1', 'O2', 'PO7', 'PO8', 'POz'}; %occipital

channels = [1:30 33:64];
plot_test = 1;
baseline_correct = 0;
mask_plot = 1;

cfg = [];
cfg.channel = channels;
%cfg.avgoverrpt = 'yes';
%cfg.parameter = {'powspctrm','powspctrm_b'};
plot_data = ft_selectdata(cfg, group_change); %group1, group2

if plot_test == 1
    plot_data.powspctrm = test.stat;
end

cfg = [];

if baseline_correct == 1
    cfg.baseline = [baseline_start baseline_end];
	cfg.baselinetype = 'db';
	data = ft_freqbaseline(cfg, data);
end


if mask_plot == 1
    plot_data.mask = test.mask;
    cfg.maskparameter = 'mask';
    
    cfg.maskstyle = 'opacity';
    cfg.masknans = 'yes';
    cfg.maskalpha = 0.2;
end

cfg.colormap = cMap;
%cfg.xlim = [-1.75, 1.75];
%cfg.ylim = [4, 40];%'maxmin';
%cfg.zlim = [-3 3];% [0, 5] 'minzero'
cfg.title = ' ';
cfg.layout = 'acticap-64ch-standard2.mat'
cfg.figure = 'gcf';
cfg.channel = 'all'; %{EEG.chanlocs.labels}, 'all';
cfg.comment = 'no';
cfg.colorbartext = 't-statistic';
cfg.parameter = 'powspctrm';


ft_singleplotTFR(cfg, plot_data);
hold on
ft_singleplotTFR(cfg, plot_data);
hold on
ft_singleplotTFR(cfg, plot_data);
hold on
ft_singleplotTFR(cfg, plot_data);
hold on
ft_singleplotTFR(cfg, plot_data);

% Extracting significant electrodes
plot_data.sig_electrodes = squeeze(nanmean(squeeze(nanmean(double(test.posclusterslabelmat),3)),2)) > 0;

%% Topography

cfg = [];
%cfg.elec = go_dif_db.elec;
cfg.channel = {'EEG', '-EOG', '-ECG'};
cfg.xlim = [-1 -0.2];        
cfg.ylim = [8 12];
%cfg.zlim = [-3 3];
cfg.title = '';
cfg.colormap = cMap;
cfg.colorbar = 'yes';
cfg.figure = 'gcf';
%cfg.frequency = foi_contrast;
cfg.layout = 'acticap-64ch-standard2.mat';
%cfg.channel = 'sig_electrodes';  % use the thresholded probability to mask the data
%cfg.maskstyle = 'box';
cfg.parameter = 'powspctrm';
%cfg.comment = 'no';
cfg.colorbartext = 't-value';
%cfg.maskfacealpha = 0.05; %0.5

ft_topoplotTFR(cfg, plot_data);

layout = ft_prepare_layout(cfg, plot_data);

ft_plot_layout(layout, 'chanindx', plot_data.sig_electrodes)

%% Macro-plotting elements

% More figures
figure(1);
subplot(3,2, [1:4]);
hold on;

% Lines
plot(zeros(size(freq_interp)), freq_interp, 'k:');

%Captions
annotation(figure(1),'textbox',...
    [0.058 0.0816666666666667 0.964 0.0433333333333334],'String',{'';'Figure 2 – A cluster-based permutation test on the baseline-corrected, decibel-transformed difference between young and older participants'; 'in correct omission trials, showing a highlighted stimulus-elicited pattern of activation in the beta band (14-24Hz) (right topography) significantly'; 'distinguishing between young and older adults as well as a preceding pattern tending in the opposite direction (left topography).'},...
    'FitBoxToText','off', 'EdgeColor', 'none');
title('Omission trial power differences in young and older participants')
xlabel({'Time (s)'})
ylabel('Frequency (Hz)')
set(gcf, 'Position',  [100, 0, 1000, 1000])
%Make background white
set(gcf,'color','w');

figure(1); 
subplot(3,2,6);
ft_topoplotTFR(cfg, plot_data);
hold on;
annotation(figure(1),'arrow',[0.568 0.387],[0.52 0.315]);
annotation(figure(1),'arrow',[0.693 0.659],[0.52 0.313]);
annotation(figure(1),'textbox',...
    [0.545000000000001 0.541 0.0809999999999997 0.151],'FitBoxToText','off');
annotation(figure(1),'textbox',...
    [0.699000000000001 0.541 0.0809999999999997 0.151],'FitBoxToText','off');
