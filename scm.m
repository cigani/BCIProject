SVMModel = fitcsvm(lpsd(:,:,10),lbl)
sv = SVMModel.SupportVectors;
figure
gscatter(lpsd(:,:,10),lpsd(:,:,10),lbl)
hold on
plot(sv(:,1),sv(:,2),'ko','MarkerSize',10)
legend('1','2','Support Vector')
hold off

% rng(1); % For reproducibility
% SVMModel = fitcsvm(lpsd(:,:,10),lbl,'Standardize',true,'KernelFunction','RBF',...
%     'KernelScale','auto');
% CVSVMModel = crossval(SVMModel);
% classLoss = kfoldLoss(CVSVMModel)