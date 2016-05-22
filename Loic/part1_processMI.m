clear;close all;clc;

%% Files locations

path = '/Users/loicjeanningros/Dropbox/Etudiants2/Project_FES/offline_FES';

path_VIS = [path '/VIS'];           % visual feedbacks
path_FES = [path '/FES'];           % FES feedbacks
path_FESnoMI = [path '/FESnoMI'];   % FES feedbacks without MI task


%% VISUAL

files = dir([path_VIS '/*.gdf']);

data.trials.VIS = [];
data.labels.VIS = [];
%data.signal.VIS = [];

for f=1:length(files)
    disp(['Loading ' path_VIS '/' files(f).name]);
    %[s.VIS,h.VIS] = sload([path_VIS '/' files(f).name]);
    %data.signal.VIS = [data.signal.VIS; s.VIS];
    [trials_file.VIS, labels_file.VIS] = gettrials2([path_VIS '/' files(f).name]);
    data.trials.VIS = [data.trials.VIS; trials_file.VIS];
    data.labels.VIS = [data.labels.VIS labels_file.VIS];
end

%% FES

files = dir([path_FES '/*.gdf']);

data.trials.FES = [];
data.labels.FES = [];
%data.signal.FES = [];

for f=1:length(files)
    disp(['Loading ' path_FES '/' files(f).name]);
    %[s.FES,h.FES] = sload([path_FES '/' files(f).name]);
    %data.signal.FES = [data.signal.FES; s.FES];
    [trials_file.FES, labels_file.FES] = gettrials2([path_FES '/' files(f).name]);
    data.trials.FES = [data.trials.FES; trials_file.FES];
    data.labels.FES = [data.labels.FES labels_file.FES];
end


%% FESnoMI

files = dir([path_FESnoMI '/*.gdf']);

data.trials.FESnoMI = [];
data.labels.FESnoMI = [];
%data.signal.FESnoMI = [];

for f=1:length(files)
    disp(['Loading ' path_FESnoMI '/' files(f).name]);
    %[s.FESnoMI,h.FESnoMI] = sload([path_FESnoMI '/' files(f).name]);
    %data.signal.FESnoMI = [data.signal.FESnoMI; s.FESnoMI];
    [trials_file.FESnoMI, labels_file.FESnoMI] = gettrials2([path_FESnoMI '/' files(f).name]);
    data.trials.FESnoMI = [data.trials.FESnoMI; trials_file.FESnoMI];
    data.labels.FESnoMI = [data.labels.FESnoMI labels_file.FESnoMI];
end

%% Parameters

parameter = struct;             % every parameter we choose
parameter.varThreshold = 1.2;   % 120% of the average of all variances, in order to detect noisy Channels
data.noisyChannels = [];        % indices of noisy channels (see spatial filtering)


%% Trials with NaNs have to be removed

[ data.trials.VIS, data.labels.VIS ] = removeNaN( data.trials.VIS, data.labels.VIS );
[ data.trials.FES, data.labels.FES ] = removeNaN( data.trials.FES, data.labels.FES );
[ data.trials.FESnoMI, data.labels.FESnoMI ] = removeNaN( data.trials.FESnoMI, data.labels.FESnoMI );



%% Spatial filtering
fprintf('Spatial filtering...');

[data.trials.VIS] = myLaplacian(data.trials.VIS,'S_LAP');
[data.trials.FES] = myLaplacian(data.trials.FES,'S_LAP');
[data.trials.FESnoMI] = myLaplacian(data.trials.FESnoMI,'S_LAP');


%% Power Spectrum Density
fprintf('Frequential transformation...');

freqWindow = 0.5:1:45.5;
samplingRate = 512;

data.spectra.VIS = powerSpectrum(data.trials.VIS, [], freqWindow, samplingRate);
data.spectra.FES = powerSpectrum(data.trials.FES, [], freqWindow, samplingRate);
data.spectra.FESnoMI = powerSpectrum(data.trials.FESnoMI, [], freqWindow, samplingRate);



%% SAVE data

save('data.mat', 'data');




