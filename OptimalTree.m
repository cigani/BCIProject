function [optTree] = TreeGet(feature, labels, minleaf)

OptimalTree = fitctree(feature,labels,'MinLeafSize',minleaf);
view(OptimalTree,'mode','graph') 
DefaultTree = fitctree(feature,labels); 
view(DefaultTree,'Mode','Graph') 
% resubOpt = resubLoss(OptimalTree); 
lossOpt = kfoldLoss(crossval(OptimalTree));%% cross validation accuracy
% resubDefault = resubLoss(DefaultTree); 
lossDefault = kfoldLoss(crossval(DefaultTree)); %% cross validation accuracy
optTree = [lossOpt,lossDefault];