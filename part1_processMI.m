clear;close all;clc;

path = '/Users/michaeljaquier/Documents/int/bci/project/data/s3.Visual';
files = dir([path '/*.gdf']);
% 1) Extract trials
trials.s3V = [];
labels.s3V = [];
signal.s3V=[];

for f=1:length(files)
    disp(['Loading ' path '/' files(f).name]);
    [s.s3V,h.s3V] = sload([path '/' files(f).name]);
    signal.s3V = [signal.s3V; s.s3V];
    [trials_file.s3V, labels_file.s3V] = gettrials([path '/' files(f).name]);
    trials.s3V = [trials.s3V; trials_file.s3V];
    labels.s3V = [labels.s3V labels_file.s3V];
end

path = '/Users/michaeljaquier/Documents/int/bci/project/data/s3.FES';
files = dir([path '/*.gdf']);
% 1) Extract trials
trials.s3F = [];
labels.s3F = [];
signal.s3F = [];

for f=1:length(files)
    disp(['Loading ' path '/' files(f).name]);
    [s.s3F,h.s3F] = sload([path '/' files(f).name]);
    signal.s3F = [signal.s3F; s.s3F];
    [trials_file.s3F, labels_file.s3F] = gettrials([path '/' files(f).name]);
    trials.s3F = [trials.s3F; trials_file.s3F];
    labels.s3F = [labels.s3F labels_file.s3F];
end





