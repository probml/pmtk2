%% Demo of using a 1d Gaussian
%#testPMTK

Xtrain = randn(10,1);
Dtrain = DataTable(Xtrain);
M = MvnDist('-ndimensions', 1);
M = fit(M, Dtrain);
LLtrain = sum(logPdf(M, Dtrain))
figure;
h= plotPdf(M); set(h, 'linewidth', 3, 'color', 'r');
X = sample(M, 1000);
hold on
[freq,bins] = hist(X);
binWidth = bins(2)-bins(1);
bar(bins, normalize(freq)/binWidth);

