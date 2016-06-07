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
    trials(i,:,:) = trial(:,:)*lap';
end

end

%% Several trials

% function [lap, trials] = manageNoisyChannels(lap, trials )
% % Detect noise in channels
% 
% noisyChannels = [];
% threshold = 6; % Maximum variance
% %th = 2;
% % Compute the variance of each channel over all trials
% for i = 1:size(trials,3)
%     var(i) = std2(trials(:,:,i));
% end
% 
% % Average of variances
% %muVar = mean(var)
% noisyVar = [];
% 
% % Save channels that are unexpectly noisy (if the channel variance is
% % greater than a defined threshold
% for i = 1:length(var)
%     if var(i) > threshold %&& var(i) < th
%         noisyChannels = [noisyChannels i];
%         noisyVar = [noisyVar var(i)];
%     end
% end
% 
% 
% for i = 1:length(noisyChannels)
%     fprintf('nC %i : var = %d.1 ; ', [noisyChannels(i), noisyVar(i)]);
% end
% if length(noisyChannels)>0
%     fprintf('N = %i \n', length(noisyChannels));
% end
% 
% % Replace Noisy channels with average of neighboors
% for j = 1:length(noisyChannels)
%     if noisyChannels(j) == 1
%         trials(:,:,noisyChannels(j)) = trials(:,:,4);
%     elseif noisyChannels(j) == 4
%         trials(:,:,noisyChannels(j)) = (trials(:,:,1)+trials(:,:,3)+trials(:,:,5)+trials(:,:,9))/4;
%     else
%            idx = [noisyChannels(j)-1, noisyChannels(j)+1, noisyChannels(j)-5, noisyChannels(j)+5];
%            idx = idx(find(idx>1 & idx <=16));
%            trials(:,:,noisyChannels(j)) = 0;
%            for k = 1:length(idx)
%                trials(:,:,noisyChannels(j)) = trials(:,:,noisyChannels(j)) + trials(:,:,idx(k))/length(idx);
%            end
%     end
% 
%     % modify the laplacian
%     lap(noisyChannels(j),:) = zeros(1,size(trials,3));
%     lap(noisyChannels(j),noisyChannels(j)) = 1;
% end
% 
% end

%% One trial

% function [lap, trial, var] = manageNoisyChannels(lap, trial)
% % Detect noise in channels
% 
% noisyChannels = [];
% threshold = 8; % Maximum variance
% %th = 2;
% % Compute the variance of each channel over all trials
% for i = 1:size(trial,2)
%     var(i) = std(trial(:,i));
% end
% 
% % Average of variances
% %muVar = mean(var)
% noisyVar = [];
% 
% % Save channels that are unexpectly noisy (if the channel variance is
% % greater than a defined threshold
% for i = 1:length(var)
%     if var(i) > threshold %&& var(i) < th
%         noisyChannels = [noisyChannels i];
%         noisyVar = [noisyVar var(i)];
%     end
% end
% 
% 
% for i = 1:length(noisyChannels)
%     fprintf('nC %i : var = %d.1 ; ', [noisyChannels(i), noisyVar(i)]);
% end
% if length(noisyChannels)>0
%     fprintf('N = %i \n', length(noisyChannels));
% end
% 
% % Replace Noisy channels with average of neighboors
% for j = 1:length(noisyChannels)
%     if noisyChannels(j) == 1
%         trial(:,noisyChannels(j)) = trial(:,4);
%     elseif noisyChannels(j) == 4
%         trial(:,noisyChannels(j)) = (trial(:,1)+trial(:,3)+trial(:,5)+trial(:,9))/4;
%     else
%            idx = [noisyChannels(j)-1, noisyChannels(j)+1, noisyChannels(j)-5, noisyChannels(j)+5];
%            idx = idx(find(idx>1 & idx <=16));
%            trial(:,noisyChannels(j)) = 0;
%            for k = 1:length(idx)
%                trial(:,noisyChannels(j)) = trial(:,noisyChannels(j)) + trial(:,idx(k))/length(idx);
%            end
%     end
% 
%     % modify the laplacian
%     %lap(noisyChannels(j),:) = zeros(1,size(trial,2));
%     %lap(noisyChannels(j),noisyChannels(j)) = 1;
% end
% 
% end

