function [rsq, p] = rsq(signal, labels)

for k = 1:size(signal,3)
    for m = 1:size(signal,2)
        [r, pd] = corrcoef(signal(:,m,k), labels);
        r = r(2);
        pd = pd(2);
        rsq(k,m) = r^2;
        p(k,m)= pd;
    end
end