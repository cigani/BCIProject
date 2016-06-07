function [ error ] = myClassifier(features, labels, classType)

% N_ft = size(features,2);
% N_tr = size(features,1);

k = 10;
cp = cvpartition(labels, 'kfold', k);

for i = 1:k
	idx.train = find(training(cp,i));
	idx.test = find(test(cp,i));
    
    set.train = features(idx.train,:);
	set.test = features(idx.test,:);
	
    class.test = classify(set.test, set.train, labels(idx.train), classType);
	error.test(i) = classerror(labels(idx.test)', class.test);

    class.train = classify(set.train, set.train, labels(idx.train), classType);
	error.train(i) = classerror(labels(idx.train)', class.train);
    
end

meanError.test = mean(error.test);
meanError.train = mean(error.train);

end

