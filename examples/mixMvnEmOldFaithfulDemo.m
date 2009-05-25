%% Fit a Mixture of Gaussians to the Old Faithful Data Set
%#testPMTK

load oldFaith;
D = DataTable(X);
m  = MixMvn('-nmixtures',2);
%m.fitEng.verbose = true;
m = fit(m,D);
post = inferLatent(m,D);
map = mode(post);
plot(X(:,1),X(:,2),'.');
hold on;
plotPdf(m.mixtureComps{1});
plotPdf(m.mixtureComps{2});
colors = {'g', 'b'};
for c=1:2
  ndx = find((map==c));
  plot(X(ndx,1),X(ndx,2), sprintf('%s.', colors{c}));
end