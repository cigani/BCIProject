function fis = fis(data, labels)

data1 = [];
data2= [];
std1 = [];
std2 = [];
fis = [];

for k = 1:size(data,3)
    for m = 1:size(data,2)
        data1 = mean(data((find(labels==l)),m,:));
        data2 = mean(data((find(labels==2)),m,:));
        std1 = std(data((find(labels==1)),m,:));
        std2 = std(data((find(labels==2)),m,:));
        fis = abs(data1-data2)/(std1^2 + std2^2);
    end
end