%% Demo of using a 2d Gaussian
%#testPMTK

Xtrain = randn(10,2);
M = MvnDist('-covType', 'spherical');
M = fit(M, DataTable(Xtrain));
figure; plotPdf(M)
X = sample(M, 1000);
hold on; scatter(X(:,1), X(:,2), '.');
LL = sum(logPdf(M, X))