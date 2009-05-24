%% Demo of using a 2d Gaussian
%#testPMTK

Xtrain = randn(10,2);
Dtrain = DataTable(Xtrain);
M = MvnDist('-ndimensions', 2, '-covType', 'diag');
M = fit(M, Dtrain);
LLtrain = sum(logPdf(M, Dtrain))
figure; plotPdf(M);
X = sample(M, 1000);
hold on; scatter(X(:,1), X(:,2), '.');
axis equal