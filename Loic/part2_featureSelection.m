clear all; close all; clc;
%% Prepare data

load('data.mat');

% Use the log of the spectrum
data.spectra.VIS = log(data.spectra.VIS);
data.spectra.FES = log(data.spectra.FES);
data.spectra.FESnoMI = log(data.spectra.FESnoMI);

% Reshape the features into a vector
data.features.VIS = reshape(data.spectra.VIS,[size(data.spectra.VIS,1), size(data.spectra.VIS,2)*size(data.spectra.VIS,3)]);
data.features.FES = reshape(data.spectra.FES,[size(data.spectra.FES,1), size(data.spectra.FES,2)*size(data.spectra.FES,3)]);
data.features.FESnoMI = reshape(data.spectra.FESnoMI,[size(data.spectra.FESnoMI,1), size(data.spectra.FESnoMI,2)*size(data.spectra.FESnoMI,3)]);

%% Feature selection, extraction & classification

% Parameters to explore
rankingType = {'fisher', 'ttest', 'relief', 'infgain'};
classType = {'linear', 'diaglinear', 'quadratic', 'diagquadratic'};
Nmax_ft = 50;
N_rep = 50;

% Feature selection 
for rank = 1:length(rankingType)

[orderedInd.VIS, orderedPower.VIS] = rankfeat(data.features.VIS, data.labels.VIS, rankingType{rank});
[orderedInd.FES, orderedPower.FES] = rankfeat(data.features.FES, data.labels.FES, rankingType{rank});
%[orderedInd.FESnoMI, orderedPower.FESnoMI] = rankfeat(data.features.FESnoMI, data.labels.FESnoMI, rankingType{rank});

for i = 1:length(orderedInd.VIS)
    [q,r] = myDivision(orderedInd.VIS(i)-1,size(data.spectra.VIS,2));
    q=q+1;r=r+1;  
    data.fSelectionPower.VIS(r,q) = orderedPower.VIS(i);
end

for i = 1:length(orderedInd.FES)
    [q,r] = myDivision(orderedInd.FES(i)-1,size(data.spectra.FES,2));
    q=q+1;r=r+1;
    data.fSelectionPower.FES(r,q) = orderedPower.FES(i);
end

figure;
set(gca,'fontsize',20)
imagesc(data.fSelectionPower.VIS')
colorbar('fontsize',20)
colormap(bone)
xlabel('Frequency [Hz]','fontsize',20);
ylabel('Channel','fontsize',20);
title([rankingType{rank} ', visual'])

figure;
set(gca,'fontsize',20)
imagesc(data.fSelectionPower.FES')
colorbar('fontsize',20)
colormap(bone)
xlabel('Frequency [Hz]','fontsize',20);
ylabel('Channel','fontsize',20);
title([rankingType{rank} ', FES'])


% Classification
for class = 1:length(classType)

disp([rankingType{rank} ', ' classType{class} ', n : ']);


for i = 1:N_rep
for n = 1:Nmax_ft


bestIdx.VIS = orderedInd.VIS(1,1:n);
bestIdx.FES = orderedInd.FES(1,1:n);
%bestIdx.FESnoMI = orderedInd.FESnoMI(1,1:n);

bestFeatures.VIS = data.features.VIS(:,bestIdx.VIS);
bestFeatures.FES = data.features.FES(:,bestIdx.FES);
%bestFeatures.FESnoMI = data.features.FESnoMI(:,bestIdx.FESnoMI);

[error] = myClassifier(bestFeatures.VIS, data.labels.VIS, classType{class});
err.test.VIS(i,n) = mean(error.test);
err.train.VIS(i,n) = mean(error.train);
errStd.test.VIS(i,n) = std(error.test);
errStd.train.VIS(i,n) = std(error.train);


[error] = myClassifier(bestFeatures.FES, data.labels.FES, classType{class});
err.test.FES(i,n) = mean(error.test);
err.train.FES(i,n) = mean(error.train);
errStd.test.FES(i,n) = std(error.test);
errStd.train.FES(i,n) = std(error.train);

% [error] = myClassifier(bestFeatures.FESnoMI, data.labels.FESnoMI, classType{class});
% err.test.FESnoMI(i,n) = mean(error.test);
% err.train.FESnoMI(i,n) = mean(error.train);

end
fprintf('\b%i',i)
end

figure;
set(gca,'fontsize',20)
shadedErrorBar(1:Nmax_ft,mean(err.test.VIS,1),mean(errStd.test.VIS,1),{'color','r','linewidth',2})
hold on
shadedErrorBar(1:Nmax_ft,mean(err.train.VIS,1),mean(errStd.train.VIS,1),{'color','b','linewidth',2})
grid on
xlabel('Number of features','fontsize',20);
ylabel('Error','fontsize',20);
title([classType{class} ', ' rankingType{rank} ', Visual'])

figure;
set(gca,'fontsize',20)
shadedErrorBar(1:Nmax_ft,mean(err.test.FES,1),mean(errStd.test.FES,1),{'color','r','linewidth',2})
hold on
shadedErrorBar(1:Nmax_ft,mean(err.train.FES,1),mean(errStd.train.FES,1),{'color','b','linewidth',2})
grid on
xlabel('Number of features','fontsize',20);
ylabel('Error','fontsize',20);
title([classType{class} ', ' rankingType{rank} ', FES'])

end
end

% figure;
% set(gca,'fontsize',20)
% shadedErrorBar(1:Nmax_ft,mean(err.test.FESnoMI,1),std(err.test.FESnoMI,1),{'color','r','linewidth',2})
% hold on
% shadedErrorBar(1:Nmax_ft,mean(err.train.FESnoMI,1),std(err.train.FESnoMI,1),{'color','b','linewidth',2})
% grid on
% xlabel('Number of features','fontsize',20);
% ylabel('Error','fontsize',20);
% title([classType ', FESnoMI'])




%fprintf([mode ' VIS : %d %d %d %d %d \n'], orderedInd.VIS(1:5))
%fprintf([mode ' FES : %d %d %d %d %d \n'], orderedInd.FES(1:5))

% for i = 1:length(orderedInd.VIS)
%     [q,r] = myDivision(orderedInd.VIS(i)-1,size(data.spectra.VIS,2));
%     q=q+1;r=r+1;
%     
%     data.fSelectionPower.VIS(r,q) = orderedPower.VIS(i);
% end
% 
% 
% for i = 1:length(orderedInd.FES)
%     [q,r] = myDivision(orderedInd.FES(i)-1,size(data.spectra.FES,2));
%     q=q+1;r=r+1;
%     data.fSelectionPower.FES(r,q) = orderedPower.FES(i);
% end

% figure;
% set(gca,'fontsize',20)
% imagesc(data.fSelectionPower.VIS')
% colorbar('fontsize',20)
% colormap(bone)
% xlabel('Frequency [Hz]','fontsize',20);
% ylabel('Channel','fontsize',20);
% title([mode ' ; Visual'])
% 
% figure;
% set(gca,'fontsize',20)
% imagesc(data.fSelectionPower.FES')
% colorbar('fontsize',20)
% colormap(bone)
% xlabel('Frequency [Hz]','fontsize',20);
% ylabel('Channel','fontsize',20);
% title([mode ' ; FES'])

%save('data2.mat','data');