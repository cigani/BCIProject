%% Initial
fs = 512;                     % Sampling frequency
electrodes = 1:16;            % Electrode count
%% Laplacian

fork = zeros([size(trials,2) size(trials,3) size(trials,1)]);
for n = 1:size(trials,1)
    lsig = trials(n,:,:);
    fork(:,:,n) = laplacianSP(permute(lsig, [2 3 1]));
end
fork = permute(fork, [3 1 2]);
%% Seperation
lbl = labels';
lbl = lbl(~isnan(fork(:,2)),:,:)';
tr = fork(~isnan(fork(:,2)),:,:);
%% PSD
leta = 0.5:0.5:32;
psd_data = ps(tr, [], leta, fs);
lpsd=log(psd_data);
%% rsq
[rs, pv] = rsq(lpsd, lbl);
imagesc(leta, electrodes, rs , 'CDataMapping', 'scaled')
set(gca,'YDir','normal','YTick', 1:16, 'XTick', 0:2:30);
xlabel('Frequency (Hz)'); ylabel('Electrode');
title('R-Squared');
%% Fisher Score
[FSc, FSc2] = fis(lpsd, lbl);
figure;
imagesc(leta, electrodes, FSc2 , 'CDataMapping', 'scaled', 'Tag', 'Fisher Score')
set(gca,'YDir','normal','YTick', 1:16, 'XTick', 0:2:30);
xlabel('Frequency (Hz)'); ylabel('Electrode');
title('Fisher Score');

%% Independant Feature Modeling
for k = 1:size(lpsd,3)
    for m = 1:size(lpsd,2)
        kl(m,k) = IndFeat(lpsd(:,m,k), lbl);      
    end
end
figure;
imagesc(leta, electrodes, kl' , 'CDataMapping', 'scaled', 'Tag', 'Fisher Score')
set(gca,'YDir','normal','YTick', 1:16, 'XTick', 0:2:30);
xlabel('Frequency (Hz)'); ylabel('Electrode');
title('Independant Feature Modeling');

%% Feature Extraction
[full_feature, optimal_feature, full_labels, optimal_labels, optcp, defcp] = FSel(FSc2, lpsd, lbl);
%% Decision tree

% Returns cross validation results for both the optimized tree and default

fulLeafSize = BestLeaf(full_feature, full_labels);
[Fopt, Fdef, FresubOpt, FresubDefault, Flopt, Fldef] = ...
    TreeGet(full_feature, full_labels, min(fulLeafSize), defcp);
figure
optLeafSize = BestLeaf(optimal_feature, optimal_labels);
[Oopt, Odef, OresubOpt, OresubDefault, Olopt, Oldef] = ...
    TreeGet(optimal_feature, optimal_labels, min(optLeafSize), optcp);


%% discrim
rng(777)
[opt_LDAx, full_LDAx, opt_PLDAx, full_PLDAx, opt_QDAx, full_QDAx, ...
    opt_diagLinearx, full_diagLinearx, opt_diagQuadratic, full_diagQuadratic, ...
    opt_pseudoQuadratic, full_pseudoQuadratic] = DADisc(optimal_feature, ...
    optimal_labels, full_feature, full_labels);

%% PCA
[coeff, score, roots, residuals, sse, pctExplained, basis] = ...
    mkPCA(optimal_feature);

%% SVA
rng(777)
X = optimal_feature;
Y = optimal_labels;
SVMModel = fitcsvm(X,Y,'KernelScale','auto');
xval =crossval(SVMModel);
loss = kfoldLoss(xval)



