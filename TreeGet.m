function [lossOpt,lossDefault, resubOpt, resubDefault l_opt, l_def] = TreeGet(feature, labels, minleaf, cvfold)

OptimalTree = fitctree(feature,labels,'MinLeafSize',minleaf);
% view(OptimalTree,'mode','graph') 
DefaultTree = fitctree(feature,labels); 
% view(DefaultTree,'Mode','Graph') 
resubOpt = resubLoss(OptimalTree); 
lossOpt = kfoldLoss(crossval(OptimalTree));%% cross validation accuracy
resubDefault = resubLoss(DefaultTree); 
lossDefault = kfoldLoss(crossval(DefaultTree)); %% cross validation accuracy

optxval = crossval(OptimalTree,'CVPartition',cvfold);
defxval = crossval(DefaultTree,'CVPartition',cvfold);
l_opt = kfoldLoss(optxval);
l_def = kfoldLoss(defxval);