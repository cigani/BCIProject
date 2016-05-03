function [coeff, score, roots, residuals, sse, pctExplained, basis] = ...
         mkPCA(data, labels)

rng(777)
[coeff,score,roots] = pca(data);
basis = coeff(:,1:2);
normal = coeff(:,3);
pctExplained = roots' ./ sum(roots);
[n,~] = size(data);
meanX = mean(data,1);
Xfit = repmat(meanX,n,1) + score(:,1:2)*coeff(:,1:2)';
residuals = data - Xfit;
error = abs((data - repmat(meanX,n,1))*normal);
sse = sum(error.^2);
dirVect = coeff(:,1);
Xfit1 = repmat(meanX,n,1) + score(:,1)*coeff(:,1)';
t = [min(score(:,1))-.2, max(score(:,1))+.2];
endpts = [meanX + t(1)*dirVect'; meanX + t(2)*dirVect'];
plot3(endpts(:,1),endpts(:,2),endpts(:,3),'k-');
X1 = [data(:,1) Xfit1(:,1) nan*ones(n,1)];
X2 = [data(:,2) Xfit1(:,2) nan*ones(n,1)];
X3 = [data(:,3) Xfit1(:,3) nan*ones(n,1)];
hold on
plot3(X1',X2',X3','b-', data(:,1),data(:,2),data(:,3),'bo');
hold off
maxlim = max(abs(data(:)))*1.1;
axis([-maxlim maxlim -maxlim maxlim -maxlim maxlim]);
axis square
view(-9,12);
grid on
figure()
pareto(pctExplained*100)
xlabel('Principal Component')
ylabel('Variance Explained (%)')
figure()
biplot(coeff(:,1:3),'scores',score(:,1:3));
axis([-.26 0.8 -.71 .71 -.71 .81]);
view([30 40]);