function [ trials, lap ] = myLaplacian( trials, mode )



N_ch = size(trials,3);
N_tr = size(trials,1);

% First apply detrend to every trial
for i = 1:N_tr
    for j = 1:N_ch
        trials(i,:,j) = detrend(trials(i,:,j));
    end
end

lap = zeros(N_ch);
for i = 1:N_ch
    lap(i,i) = 1;
end

switch mode
    case 'CAR'
        lap = lap - 1/N_ch;
    
    case 'S_LAP'
        lap(1,4) = -1;
        lap(2,3) = -1/2; lap(2,7) = -1/2;
        lap(3,2) = -1/3; lap(3,4) = -1/3; lap(3,8) = -1/3;
        lap(4,1) = -1/4; lap(4,3) = -1/4; lap(4,5) = -1/4; lap(4,9) = -1/4;
        lap(5,4) = -1/3; lap(5,6) = -1/3; lap(5,10) = -1/3;
        lap(6,5) = -1/2; lap(6,11) = -1/2;
        lap(7,2) = -1/3; lap(7,8) = -1/3; lap(7,12) = -1/3;
        lap(8,3) = -1/4; lap(8,7) = -1/4; lap(8,9) = -1/4; lap(8,13) = -1/4;
        lap(9,4) = -1/4; lap(9,8) = -1/4; lap(9,10) = -1/4; lap(9,14) = -1/4;
        lap(10,5) = -1/4; lap(10,11) = -1/4; lap(10,9) = -1/4; lap(10,15) = -1/4;
        lap(11,6) = -1/3; lap(11,10) = -1/3; lap(11,16) = -1/3;
        lap(12,7) = -1/2; lap(12,13) = -1/2;
        lap(13,8) = -1/3; lap(13,12) = -1/3; lap(13,14) = -1/3;
        lap(14,9) = -1/3; lap(14,13) = -1/3; lap(14,15) = -1/3;
        lap(15,10) = -1/3; lap(15,14) = -1/3; lap(15,16) = -1/3;
        lap(16,11) = -1/2; lap(16,15) = -1/2;

    case 'L_LAP'
        lap(1,9) = -1;
        lap(2,12) = -1/2; lap(2,4) = -1/2;
        lap(3,2) = -1/3; lap(3,5) = -1/3; lap(3,13) = -1/3;
        lap(4,1) = -1/4; lap(4,2) = -1/4; lap(4,6) = -1/4; lap(4,14) = -1/4;
        lap(5,3) = -1/3; lap(5,6) = -1/3; lap(5,15) = -1/3;
        lap(6,4) = -1/2; lap(6,16) = -1/2;
        lap(7,2) = -1/3; lap(7,9) = -1/3; lap(7,12) = -1/3;
        lap(8,3) = -1/4; lap(8,7) = -1/4; lap(8,10) = -1/4; lap(8,13) = -1/4;
        lap(9,1) = -1/4; lap(9,7) = -1/4; lap(9,11) = -1/4; lap(9,14) = -1/4;
        lap(10,5) = -1/4; lap(10,8) = -1/4; lap(10,11) = -1/4; lap(10,15) = -1/4;
        lap(11,6) = -1/3; lap(11,9) = -1/3; lap(11,16) = -1/3;
        lap(12,2) = -1/2; lap(12,14) = -1/2;
        lap(13,3) = -1/3; lap(13,12) = -1/3; lap(13,15) = -1/3;
        lap(14,4) = -1/3; lap(14,12) = -1/3; lap(14,16) = -1/3;
        lap(15,5) = -1/3; lap(15,13) = -1/3; lap(15,16) = -1/3;
        lap(16,6) = -1/2; lap(16,14) = -1/2;
end


for i = 1:N_tr
    trial(:,:) = trials(i,:,:);
    [lap1, trial] = manageNoisyChannels(lap, trial);
    trials(i,:,:) = trial(:,:)*lap1';
end

end


function [lap, trial] = manageNoisyChannels(lap, trial )
% Detect noise in channels

noisyChannels = [];
threshold = 1.5; % 150% greater than the total variance is our threshold.

% Compute the variance of each channel over all trials
for i = 1:size(trial,2)
    var(i) = std(trial(:,i));
end

% Average of variances
muVar = mean(var);

% Save channels that are unexpectly noisy (if the channel variance is
% greater than a defined threshold
for i = 1:length(var)
    if var(i)/muVar > threshold
        noisyChannels = [noisyChannels i];
    end
end

% Replace Noisy channels with average of neighboors
for j = 1:length(noisyChannels)
    fprintf('%i noisy channel(s) % \n', length(noisyChannels));
    if noisyChannels(j) == 1
        trial(:,noisyChannels(j)) = trial(:,4);
    elseif noisyChannels(j) == 4
        trial(:,noisyChannels(j)) = (trial(:,1)+trial(:,3)+trial(:,5)+trial(:,9))/4;
    else
           idx = [noisyChannels(j)-1, noisyChannels(j)+1, noisyChannels(j)-5, noisyChannels(j)+5];
           idx = idx(find(idx>1 & idx <=16));
           trial(:,noisyChannels(j)) = 0;
           for k = 1:length(idx)
               trial(:,noisyChannels(j)) = trial(:,noisyChannels(j)) + trial(:,idx(k))/length(idx);
           end
    end
    
    % modify the laplacian
    lap(noisyChannels(j),:) = zeros(1,size(trial,2));
    lap(noisyChannels(j),noisyChannels(j)) = 1;
end

end

