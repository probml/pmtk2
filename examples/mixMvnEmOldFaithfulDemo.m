%% Fit a Mixture of Gaussians to the Old Faithful Data Set
%#testPMTK

load oldFaith;
D = DataTable(X);
m  = MixMvn('-nmixtures',2);
m.fitEng.verbose = true;
m = fit(m,D);
% Desired
%[Zhat, post] = inferLatent(m,D);
%assertIsequal(Zhat,  mode(post));
% Current
pZ = inferLatent(m,D);
Zhat = mode(pZ);
hold on;
colors = {'g', 'b'};
for c=1:2
  plotPdf(m.mixtureComps{c});
  ndx = find((Zhat==c));
  plot(X(ndx,1),X(ndx,2), sprintf('%s.', colors{c}));
end

