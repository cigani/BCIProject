function bleaf = BestLeaf(features, labels)

rng(777)
leafs = logspace(1,2,10);
N = numel(leafs);
err = zeros(N,1);
for n=1:N
    t = fitctree(features,labels,'CrossVal','On',...
        'MinLeafSize',leafs(n));
    err(n) = kfoldLoss(t);
end

plot(leafs,err);  %% Suppressed plotting.
xlabel('Min Leaf Size');
ylabel('cross-validated error');

indexmin = find(min(err) == err);
xmin = leafs(indexmin);
ymin = err(indexmin);
strmin1 = ['Minimum = ',num2str(xmin)];
text(xmin,ymin,strmin1,'HorizontalAlignment','left');
bleaf = xmin;