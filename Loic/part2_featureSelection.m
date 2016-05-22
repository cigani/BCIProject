clear all; close all; clc;
%%
% Feature selection 
load('data.mat');

data.spectra.VIS = log(data.spectra.VIS);
data.spectra.FES = log(data.spectra.FES);
data.spectra.FESnoMI = log(data.spectra.FESnoMI);

[orderedInd.VIS, orderedPower.VIS] = rankfeat(data.spectra.VIS, data.labels.VIS, 'fisher');
[orderedInd.FES, orderedPower.FES] = rankfeat(data.spectra.FES, data.labels.FES, 'fisher');
