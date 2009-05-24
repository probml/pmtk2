%% Fit a Mixture of Gaussians to the Old Faithful Data Set
%#testPMTK

load oldFaith;
D = DataTable(X);
m  = MixMvn('-nmixtures',2);
m = fit(m,D);
post = inferLatent(m,D);
plot(X(:,1),X(:,2),'.');
hold on;
plotPdf(m.mixtureComps{1});
plotPdf(m.mixtureComps{2});