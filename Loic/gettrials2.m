function [trials,labels] = gettrials2(FilePath)

% Receives path to a GDF file recorded with the CNBI MI offline protocol
% with 3 classes (RH, LH F)  and returns a 3D matrix trials: 
% Ntrials x Nsamples x Channels and a vector of size Ntrials with the 
% trial labels

% Sampling rate
fs = 512;
HiAmp = 1;

% ADD BIOSIG TOOL
%     addpath(genpath('../biosig/'));


[data,header] = sload(FilePath);
data = data(:,1:64);

if HiAmp == 1
    car_matrix = eye(64,64);

    idx_nodiag = car_matrix==0;
    idx_diag = car_matrix==1;
    car_matrix(idx_diag) = 58/59;
    car_matrix(idx_nodiag) = -1/59;
    car_matrix([47 61 62 63 64],:) = 0;
    car_matrix(:,[47 61 62 63 64]) = 0;

    linked_ear_matrix = eye(64,64);
    linked_ear_matrix(:,[63 64]) = -1/2;
    linked_ear_matrix([63 64],:) = -1/2;

    spatial_matrix = car_matrix*linked_ear_matrix;
    data = spatial_matrix*data';
    data = data';
    data(:,47) =  mean(data(:, [38 48 46 54]),2);
 

    electrode = [12 19 20 21 22 23 28 29 30 31 32 37 38 39 40 41];
    data = data(:,electrode);
end


% Find beginning of each trial (cfeedback)
Ind781 = find(header.EVENT.TYP == 781);

% Build 3D trial matrix
% Data are from 781 + DUR, (should be around 4 seconds)
% Drop trigger channel

for tr=1:length(Ind781)
    
    %start = header.EVENT.POS(Ind781(tr))-fs;
    start = header.EVENT.POS(Ind781(tr));
    
    % Fix duration
    %dur = header.EVENT.DUR(Ind781(tr));
    %dur = 5*fs-1;
    dur = 4*fs-1;
    
    trials(tr,:,:) = data(start:start+dur,1:16);
    labels(tr) = header.EVENT.TYP(Ind781(tr)-1);
end


% Relabel labels

labels(labels==770|labels==769)=1;
labels(labels==783)=2;
%labels(labels==771)=3;