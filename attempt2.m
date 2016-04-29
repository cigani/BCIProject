%% Initial
fs = 512;                     % Sampling frequency
electrodes = 1:16;            % Electrode count
s3V = trials.s3V;
s3VL = labels.s3V;
s3F = trials.s3F;
s3FL = labels.s3V;
%% Laplacian

fork.s3V = zeros([size(s3V,2) size(s3V,3) size(s3V,1)]);
fork.s3F = zeros([size(s3F,2) size(s3F,3) size(s3F,1)]);
for n = 1:size(s3V,1)
    s3Vsig = s3V(n,:,:);
    fork.s3V(:,:,n) = laplacianSP(permute(s3Vsig, [2 3 1]));
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
leta = 0.5:0.5:32;

psd_data.s3V = ps(tr.s3V, [], leta, fs);
lpsd.s3V=log(psd_data.s3V);

psd_data.s3F = ps(tr.s3F, [], leta, fs);
lpsd.s3F=log(psd_data.s3F);
%% rsq
[rs.s3V] = rsq(lpsd.s3V, lbl.s3V);
imagesc(leta, electrodes, rs , 'CDataMapping', 'scaled')
set(gca,'YDir','normal','YTick', 1:16, 'XTick', 0:2:30);
xlabel('Frequency (Hz)'); ylabel('Electrode');
title('Visual - R-Squared');

[rs.s3F] = rsq(lpsd.s3F, lbl.s3F);
imagesc(leta, electrodes, rs , 'CDataMapping', 'scaled')
set(gca,'YDir','normal','YTick', 1:16, 'XTick', 0:2:30);
xlabel('Frequency (Hz)'); ylabel('Electrode');
title('FES - R-Squared');
%% Fisher Score
FSc.s3V = fis(lpsd.s3V, lbl.s3V);
figure;
imagesc(leta, electrodes, FSc.s3V , 'CDataMapping', 'scaled', 'Tag', 'Fisher Score')
set(gca,'YDir','normal','YTick', 1:16, 'XTick', 0:2:30);
xlabel('Frequency (Hz)'); ylabel('Electrode');
title('Visual - Fisher Score');

FSc.s3F = fis(lpsd.s3F, lbl.s3F);
figure;
imagesc(leta, electrodes, FSc.s3F , 'CDataMapping', 'scaled', 'Tag', 'Fisher Score')
set(gca,'YDir','normal','YTick', 1:16, 'XTick', 0:2:30);
xlabel('Frequency (Hz)'); ylabel('Electrode');
title('FES - Fisher Score');

%% Independant Feature Modeling
for k = 1:size(lpsd.s3V,3)
    for m = 1:size(lpsd.s3V,2)
        kl.s3V(m,k) = IndFeat(lpsd.s3V(:,m,k), lbl.s3V);      
    end
end
figure;
imagesc(leta, electrodes, kl.s3V' , 'CDataMapping', 'scaled', 'Tag', 'Independant Feature Modeling')
set(gca,'YDir','normal','YTick', 1:16, 'XTick', 0:2:30);
xlabel('Frequency (Hz)'); ylabel('Electrode');
title('Visual - Independant Feature Modeling');

for k = 1:size(lpsd.s3F,3)
    for m = 1:size(lpsd.s3F,2)
        kl.s3F(m,k) = IndFeat(lpsd.s3F(:,m,k), lbl.s3F);      
    end
end
figure;
imagesc(leta, electrodes, kl.s3F' , 'CDataMapping', 'scaled', 'Tag', 'Independant Feature Modeling')
set(gca,'YDir','normal','YTick', 1:16, 'XTick', 0:2:30);
xlabel('Frequency (Hz)'); ylabel('Electrode');
title('FES - Independant Feature Modeling');
%% PCA
[coeff.s3V, score.s3V, roots.s3V, residuals.s3V, sse.s3V, pctExplained.s3V, basis.s3V] = ...
    mkPCA(lpsd.s3V,lbl.s3V)

[coeff.s3F, score.s3F, roots.s3F, residuals.s3F, sse.s3F, pctExplained.s3F, basis.s3F] = ...
    mkPCA(lpsd.s3F,lbl.s3F)
%% Feature Extraction
[~, optimal_feature.s3V, ~, optimal_labels.s3V, ~, ~] = FSel(FSc.s3V, lpsd.s3V, lbl.s3V);
[~, optimal_feature.s3F, ~, optimal_labels.s3F, ~, ~] = FSel(FSc.s3F, lpsd.s3F, lbl.s3F);

%% Decision tree
% 
% % Returns cross validation results for both the optimized tree and default
% 
% fulLeafSize = BestLeaf(full_feature, full_labels);
% [Fopt, Fdef, FresubOpt, FresubDefault, Flopt, Fldef] = ...
%     TreeGet(full_feature, full_labels, min(fulLeafSize), defcp);
% figure
% optLeafSize = BestLeaf(optimal_feature, optimal_labels);
% [Oopt, Odef, OresubOpt, OresubDefault, Olopt, Oldef] = ...
%     TreeGet(optimal_feature, optimal_labels, min(optLeafSize), optcp);


%% discrim
rng(777)
[LDA_opt.s3V, opt_LDAx.s3V] = DADisc(optimal_feature.s3V, ...
    optimal_labels.s3V);
[LDA_opt.s3F, opt_LDAx.s3F] = DADisc(optimal_feature.s3F, ...
    optimal_labels.s3F);

%% SVA
rng(777)

X.s3V = optimal_feature.s3V;
Y.s3V = optimal_labels.s3V;
SVMModel.s3V = fitcsvm(X.s3V,Y.s3V,'KernelScale','auto');
xval.s3V =crossval(SVMModel.s3V);
loss.s3V = kfoldLoss(xval.s3V)

Y.s3F = optimal_labels.s3F;
SVMModel.s3F = fitcsvm(X.s3F,Y.s3F,'KernelScale','auto');
xval.s3F =crossval(SVMModel.s3F);
loss.s3F = kfoldLoss(xval.s3F)



