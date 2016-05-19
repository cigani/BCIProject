%% Initial
fs = 512;                     % Sampling frequency
electrodes = 1:16;            % Electrode count

s3V = trials.s3V; 
s3VL = labels.s3V;

s3F = trials.s3F;
s3FL = labels.s3F;

pleta = 1:25; % Feature Extraction Frequencies 
leta = 0.5:1:45; % PSD Frequencies 
%% Laplacian

fork.s3V = zeros([size(s3V,2) size(s3V,3) size(s3V,1)]);
fork.s3F = zeros([size(s3F,2) size(s3F,3) size(s3F,1)]);
for n = 1:size(s3V,1)
    s3Vsig = s3V(n,:,:);
    fork.s3V(:,:,n) = laplacianSP(permute(s3Vsig, [2 3 1]));
end
for n = 1:size(s3F,1)
    s3Fsig = s3F(n,:,:);
    fork.s3F(:,:,n) = laplacianSP(permute(s3Fsig, [2 3 1]));
end
fork.s3V = permute(fork.s3V, [3 1 2]);
fork.s3F = permute(fork.s3F, [3 1 2]);
%% Seperation
lbl.s3V = s3VL';
lbl.s3V = lbl.s3V(~isnan(fork.s3V(:,2)),:,:)';
tr.s3V = fork.s3V(~isnan(fork.s3V(:,2)),:,:);

lbl.s3F = s3FL';
lbl.s3F = lbl.s3F(~isnan(fork.s3F(:,2)),:,:)';
tr.s3F = fork.s3F(~isnan(fork.s3F(:,2)),:,:);
%% PSD
psd_data.s3V = ps(tr.s3V, [], leta, fs);
lpsd.s3V=log(psd_data.s3V);

psd_data.s3F = ps(tr.s3F, [], leta, fs);
lpsd.s3F=log(psd_data.s3F);
%% rsq
[rs.s3V] = rsq(lpsd.s3V(:,:,:), lbl.s3V);
imagesc(leta, electrodes, rs.s3V , 'CDataMapping', 'scaled')
set(gca,'YDir','normal','YTick', 1:16, 'XTick', 0:2:30);
xlabel('Frequency (Hz)'); ylabel('Electrode');
title('Visual - R-Squared');
figure
[rs.s3F] = rsq(lpsd.s3F(:,:,:), lbl.s3F);
imagesc(leta, electrodes, rs.s3F , 'CDataMapping', 'scaled')
set(gca,'YDir','normal','YTick', 1:16, 'XTick', 0:2:30);
xlabel('Frequency (Hz)'); ylabel('Electrode');
title('FES - R-Squared');
%% Fisher Score

FSc.s3V = fis(lpsd.s3V(:,:,:), lbl.s3V);
figure;
imagesc(leta, electrodes, FSc.s3V , 'CDataMapping', 'scaled', 'Tag', 'Fisher Score')
set(gca,'YDir','normal','YTick', 1:16, 'XTick', 0:2:45);
xlabel('Frequency (Hz)'); ylabel('Electrode');
title('Visual - Fisher Score');

FSc.s3F = fis(lpsd.s3F(:,:,:), lbl.s3F);
figure;
imagesc(leta, electrodes, FSc.s3F , 'CDataMapping', 'scaled', 'Tag', 'Fisher Score')
set(gca,'YDir','normal','YTick', 1:16, 'XTick', 0:2:45);
xlabel('Frequency (Hz)'); ylabel('Electrode');
title('FES - Fisher Score');

%% Independant Feature Modeling
 kl.s3V = [];
 kl.s3F = [];
for k = 1:size(lpsd.s3V,3)
    kl.s3V(k,:) = IndFeat(lpsd.s3V(:,:,k), lbl.s3V);
    
end
imagesc(leta, electrodes, kl.s3V , 'CDataMapping', 'scaled', 'Tag', 'Independant Feature Modeling')
set(gca,'YDir','normal','YTick', 1:16, 'XTick', 0:2:45);
xlabel('Frequency (Hz)'); ylabel('Electrode');
title('Visual - Independant Feature Modeling');
figure
for k = 1:size(lpsd.s3F,3)
    kl.s3F(k,:) = IndFeat(lpsd.s3F(:,:,k), lbl.s3F);
end
imagesc(leta, electrodes, kl.s3F , 'CDataMapping', 'scaled', 'Tag', 'Independant Feature Modeling')
set(gca,'YDir','normal','YTick', 1:16, 'XTick', 0:2:45);
xlabel('Frequency (Hz)'); ylabel('Electrode');
title('FES - Independant Feature Modeling');
%% PCA [Needs work]
% % cata = num2cell(leta');
% [coeff.s3V, score.s3V, roots.s3V, residuals.s3V, sse.s3V, pctExplained.s3V, basis.s3V] = ...
%     mkPCA(lpsd.s3V(:,:,9))
% [coeff.s3F, score.s3F, roots.s3F, residuals.s3F, sse.s3F, pctExplained.s3F, basis.s3F] = ...
%    mkPCA(lpsd.s3F(:,:,9))
%% Feature Extraction
lim.s3V = 0.60;
lim.s3F = 0.190;
[~, optimal_feature.s3V, ~, optimal_labels.s3V, optcp.s3V, ~] = FSel(FSc.s3V(:,pleta), lpsd.s3V(:,pleta,:), lbl.s3V, lim.s3V);
[~, optimal_feature.s3F, ~, optimal_labels.s3F, optcp.s3F, ~] = FSel(FSc.s3F(:,pleta), lpsd.s3F(:,pleta,:), lbl.s3F, lim.s3F);

%% discrim
rng(777)
[LDA_opt.s3V, opt_LDAx.s3V, QDA_opt.s3V, opt_QDAx.s3V] = DADisc(optimal_feature.s3V, ...
    optimal_labels.s3V);
[LDA_opt.s3F, opt_LDAx.s3F, QDA_opt.s3F, opt_QDAx.s3F] = DADisc(optimal_feature.s3F, ...
    optimal_labels.s3F)

%% SVA
rng(777)

X.s3V = optimal_feature.s3V;
Y.s3V = optimal_labels.s3V;
SVMModel.s3V = fitcsvm(X.s3V,Y.s3V,'KernelScale','auto');
xval.s3V =crossval(SVMModel.s3V);
loss.s3V = kfoldLoss(xval.s3V);

X.s3F = optimal_feature.s3F;
Y.s3F = optimal_labels.s3F;
SVMModel.s3F = fitcsvm(X.s3F,Y.s3F,'KernelScale','auto');
xval.s3F =crossval(SVMModel.s3F);
loss.s3F = kfoldLoss(xval.s3F)

%% mean plot

svmean.MI = mean(lpsd.s3V(find(lbl.s3V==1),:,:));
sfmean.MI = mean(lpsd.s3F(find(lbl.s3F==1),:,:));
svmean.R = mean(lpsd.s3V(find(lbl.s3V==2),:,:));
sfmean.R = mean(lpsd.s3F(find(lbl.s3F==2),:,:));

for n = 1:16
    hold on
    plot(leta, 10*log10(svmean.MI(:,:,n)), 'k','DisplayName', 'Visual - MI');
    plot(leta, 10*log10(sfmean.MI(:,:,n)), 'm','DisplayName', 'FES - MI');
    plot(leta, 10*log10(svmean.R(:,:,n)), 'b','LineStyle','--','DisplayName', 'Visual - Rest');
    plot(leta, 10*log10(sfmean.R(:,:,n)), 'r','LineStyle','--','DisplayName', 'FES - Rest');
    xlabel('Frequency (Hz)')
    ylabel('Magnitude (dB)')
    hold off
    figure
end


%% Feature Selection Plot

figure()
subplot(3,2,1)
imagesc(leta, electrodes, rs.s3V , 'CDataMapping', 'scaled')
set(gca,'YDir','normal','YTick', 1:16, 'XTick', 0:2:45);
xlabel('Frequency (Hz)'); ylabel('Electrode');
title('Visual - R-Squared');
subplot(3,2,2)
imagesc(leta, electrodes, rs.s3F , 'CDataMapping', 'scaled')
set(gca,'YDir','normal','YTick', 1:16, 'XTick', 0:2:45);
xlabel('Frequency (Hz)'); ylabel('Electrode');
title('FES - R-Squared');
subplot(3,2,3)
imagesc(leta, electrodes, FSc.s3V , 'CDataMapping', 'scaled', 'Tag', 'Fisher Score')
set(gca,'YDir','normal','YTick', 1:16, 'XTick', 0:2:45);
xlabel('Frequency (Hz)'); ylabel('Electrode');
title('Visual - Fisher Score');
subplot(3,2,4)
imagesc(leta, electrodes, FSc.s3F , 'CDataMapping', 'scaled', 'Tag', 'Fisher Score')
set(gca,'YDir','normal','YTick', 1:16, 'XTick', 0:2:45);
xlabel('Frequency (Hz)'); ylabel('Electrode');
title('FES - Fisher Score');
subplot(3,2,5)
imagesc(leta, electrodes, kl.s3V , 'CDataMapping', 'scaled', 'Tag', 'Independant Feature Modeling')
set(gca,'YDir','normal','YTick', 1:16, 'XTick', 0:2:45);
xlabel('Frequency (Hz)'); ylabel('Electrode');
title('Visual - Independant Feature Modeling');
subplot(3,2,6)
imagesc(leta, electrodes, kl.s3F, 'CDataMapping', 'scaled', 'Tag', 'Independant Feature Modeling')
set(gca,'YDir','normal','YTick', 1:16, 'XTick', 0:2:45);
xlabel('Frequency (Hz)'); ylabel('Electrode');
title('FES - Independant Feature Modeling');

%% Plot Classifier 
figure
ybar = [opt_LDAx.s3V, opt_LDAx.s3F, opt_QDAx.s3V, opt_QDAx.s3F, loss.s3V, loss.s3F];
bar(1:6, ybar)
set(gca,'XtickLabel',{'LDA - Visual', 'LDA - FES','QDA - Visual', 'QDA - FES', 'SVM - Visual', 'SVM - FES'})
h = bar(1:6,diag(ybar),'stacked'); 
set(gca,'XtickLabel',{'LDA - Visual', 'LDA - FES','QDA - Visual', 'QDA - FES', 'SVM - Visual', 'SVM - FES'})