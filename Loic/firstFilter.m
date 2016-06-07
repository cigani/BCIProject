function [ trials ] = firstFilter( trials, param )

N_tr = size(trials,1);
N_ch = size(trials,3);
load('firstNeighbors.mat');

fc = 60;
Wn = (2/param.sampleRate)*fc;
b = fir1(20,Wn,'low',kaiser(21,3));

for i = 1:N_tr
    for j = 1:N_ch
        trials(i,:,j) = detrend(trials(i,:,j));
        trials(i,:,j) = filter(b,1,trials(i,:,j));
        variance(i,j) = std(trials(i,:,j));
    end
end

% figure;
% set(gca,'fontsize',20)
% imagesc(variance')
% colorbar('fontsize',20)
% xlabel('Trial','fontsize',20);
% ylabel('Channel','fontsize',20);
% title('Standard Deviation')

for i = 1:N_tr
    trial(:,:) = trials(i,:,:);
    %fprintf('Trial %i: ', i);
    trials(i,:,:) = manageNoisyChannels(trial, variance(i,:), firstNeighbors);
end

end

function [trial] = manageNoisyChannels(trial, variance, firstNeighbors)
% Detect noise in channels

N_ch = size(trial,2);
threshold = 7; % Maximum variance
noisyChannels = find(variance > threshold);
neighbors = firstNeighbors;


for i = 1:length(noisyChannels)
    %fprintf('Ch %i, ', noisyChannels(i));
    neighbors(noisyChannels(i),:) = zeros(1,N_ch);
end
%fprintf('N = %i \n', length(noisyChannels));


for i = 1:length(noisyChannels)
    if length(find(neighbors(:,noisyChannels(i))==1)) == 0;
        noNoiseChannels = setdiff(1:N_ch,noisyChannels);
        neighbors(noNoiseChannels,noisyChannels(i)) = 1;
        disp('ManageNoisyChannels : One channel has been replaced by common average');
    end
    
    trial(:,noisyChannels(i)) = trial(:,:)*neighbors(:,noisyChannels(i))/length(find(neighbors(:,noisyChannels(i))==1));
    
end

end