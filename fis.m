function [fis, fishsq] = fis(data, labels)


fis = zeros(size(data,3), size(data,2));
fishsq = zeros(size(data,3), size(data,2));
for k = 1:size(data,3)
    for m = 1:size(data,2)
        data1 = mean(data((find(labels==1)),m,k));
        data2 = mean(data((find(labels==2)),m,k));
        std1 = std(data((find(labels==1)),m,k));
        std2 = std(data((find(labels==2)),m,k));
        fis(k,m) = (data1-data2)^2/(std1^2 + std2^2);
    end
end

for k = 1:size(data,3)
    for m = 1:size(data,2)
        data1 = mean(data((find(labels==1)),m,k));
        data2 = mean(data((find(labels==2)),m,k));
        std1 = std(data((find(labels==1)),m,k));
        std2 = std(data((find(labels==2)),m,k));
        fishsq(k,m) = (data1-data2)^2/(std1^2 + std2^2);
    end
end