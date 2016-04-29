clear;close all;clc;

path = '/Users/michaeljaquier/Documents/int/bci/project/data/s3.Visual';
files = dir([path '/*.gdf']);
% 1) Extract trials
trials.s3V = [];
labels.s3V = [];
signal.s3V=[];

for f=1:length(files)
    disp(['Loading ' path '/' files(f).name]);
    [s,h] = sload([path '/' files(f).name]);
    signal.s3V = [signal.s3V; s];
    [trials_file, labels_file] = gettrials([path '/' files(f).name]);
    trials.s3V = [trials.s3V; trials_file];
    labels.s3V = [labels.s3V labels_file];
end

path = '/Users/michaeljaquier/Documents/int/bci/project/data/s3.FES';
files = dir([path '/*.gdf']);
% 1) Extract trials
trials.s3F = [];
labels.s3F = [];
signal.s3F=[];

for f=1:length(files)
    disp(['Loading ' path '/' files(f).name]);
    [s,h] = sload([path '/' files(f).name]);
    signal.s3F = [signal.s3F; s];
    [trials_file, labels_file] = gettrials([path '/' files(f).name]);
    trials.s3F = [trials.s3F; trials_file];
    labels.s3F = [labels.s3F labels_file];
end





