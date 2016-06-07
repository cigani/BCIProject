clear;close all;clc;

%% Files locations

path = '/Users/loicjeanningros/Dropbox/Etudiants2/Project_FES/offline_FES';

path_VIS = [path '/VIS'];           % visual feedbacks
path_FES = [path '/FES'];           % FES feedbacks
path_FESnoMI = [path '/FESnoMI'];   % FES feedbacks without MI task

param.sampleRate = 512;


%% VISUAL

files = dir([path_VIS '/*.gdf']);

data.trials.VIS = [];
data.labels.VIS = [];

for f=1:length(files)
    disp(['Loading ' path_VIS '/' files(f).name]);
    [trials_file.VIS, labels_file.VIS] = gettrials2([path_VIS '/' files(f).name]);
    
    [trials_file.VIS, labels_file.VIS] = removeNaN( trials_file.VIS, labels_file.VIS );
    trials_file.VIS = firstFilter(trials_file.VIS, param);
    [trials_file.VIS] = myLaplacian(trials_file.VIS,'CAR');
    
    data.trials.VIS = [data.trials.VIS; trials_file.VIS];
    data.labels.VIS = [data.labels.VIS labels_file.VIS];
end

display_signal(data.trials.VIS,'Spacial filtering VIS');

%% FES

files = dir([path_FES '/*.gdf']);

data.trials.FES = [];
data.labels.FES = [];

for f=1:length(files)
    disp(['Loading ' path_FES '/' files(f).name]);
    [trials_file.FES, labels_file.FES] = gettrials2([path_FES '/' files(f).name]);
    
    [trials_file.FES, labels_file.FES] = removeNaN( trials_file.FES, labels_file.FES );
    trials_file.FES = firstFilter(trials_file.FES, param);
    [trials_file.FES] = myLaplacian(trials_file.FES,'CAR');
    
    data.trials.FES = [data.trials.FES; trials_file.FES];
    data.labels.FES = [data.labels.FES labels_file.FES];
end

display_signal(data.trials.FES,'Spacial filtering FES');

%% FESnoMI

files = dir([path_FESnoMI '/*.gdf']);

data.trials.FESnoMI = [];
data.labels.FESnoMI = [];

for f=1:length(files)
    disp(['Loading ' path_FESnoMI '/' files(f).name]);
    [trials_file.FESnoMI, labels_file.FESnoMI] = gettrials2([path_FESnoMI '/' files(f).name]);
    
    [trials_file.FESnoMI, labels_file.FESnoMI] = removeNaN( trials_file.FESnoMI, labels_file.FESnoMI );
    trials_file.FESnoMI = firstFilter(trials_file.FESnoMI, param);
    [trials_file.FESnoMI] = myLaplacian(trials_file.FESnoMI,'CAR');
    
    data.trials.FESnoMI = [data.trials.FESnoMI; trials_file.FESnoMI];
    data.labels.FESnoMI = [data.labels.FESnoMI labels_file.FESnoMI];
end

display_signal(data.trials.FESnoMI,'Spacial filtering FESnoMI');


%% Power Spectrum Density

fprintf('Frequential transformation...');

freqWindow = 0.5:1:45.5;
samplingRate = 512;

data.spectra.VIS = powerSpectrum(data.trials.VIS, [], freqWindow, samplingRate);
data.spectra.FES = powerSpectrum(data.trials.FES, [], freqWindow, samplingRate);
data.spectra.FESnoMI = powerSpectrum(data.trials.FESnoMI, [], freqWindow, samplingRate);

%% SAVE data

save('data.mat', 'data');




