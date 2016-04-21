function [fsel, opt_features, feature_labels, opt_labels, optcp, defcp] = FSel(stat, data, labels)

fsel2 = data; % data(:,:,unique(mod(find((stat>0.69)),16)));
% fsel1 = permute(fsel2,[1 3 2]);
fsel = reshape(fsel2,size(fsel2,1),[]); %reshape(fsel1,[],size(fsel2,2),1)
% fsel = reshape(fsel,[],1);
feature_labels = repmat(labels',(size(fsel,1)/size(data,1)),1);

% opt_features3 = [mod(find((stat>0.7)), size(data,3)) mod(find((stat'>0.7)),...
%     size(data,2))];
% opt_features2 = data(:,opt_features3(:,2), opt_features3(:,1));
% opt_features1 = permute(opt_features2,[1 3 2]);
% opt_features = reshape(opt_features1,[],size(opt_features2,2),1);

opt_features = data(:,stat>.42);
% opt_features = reshape(opt_features,[],1);

opt_labels = repmat(labels',(size(opt_features,1)/size(data,1)),1);

optcp = cvpartition(opt_labels,'KFold',10);
defcp = cvpartition(feature_labels,'KFold',10);
