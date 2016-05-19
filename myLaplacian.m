function [ signal, lap ] = myLaplacian( signal, noisyChannels, mode )



N_ch = size(signal,3);
N_tr = size(signal,1);

% Replace Noisy channels with average of neighboors
for j = 1:length(noisyChannels)
    if noisyChannels(j) == 1
        signal(:,:,noisyChannels(j)) = signal(:,:,4);
    elseif noisyChannels == 4
        signal(:,:,noisyChannels(j)) = (signal(:,:,1)+signal(:,:,3)+signal(:,:,5)+signal(:,:,9))/4;
    else
           idx = [noisyChannels(j)-1, noisyChannels(j)+1, noisyChannels(j)-5, noisyChannels(j)+5];
           idx = idx(find(idx>1 & idx <=16));
           signal(:,:,noisyChannels(j)) = 0;
           for k = 1:length(idx)
               signal(:,:,noisyChannels(j)) = signal(:,:,noisyChannels(j)) + signal(:,:,idx(k))/length(idx);
           end
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

for j = 1:length(noisyChannels) 
    lap(noisyChannels(j),:) = zeros(1,N_ch);
    lap(noisyChannels(j),noisyChannels(j)) = 1;
end

for i = 1:N_tr
    trial(:,:) = signal(i,:,:);
    signal(i,:,:) = trial(:,:)*lap';
end

end

