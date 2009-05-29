
%% Point Estimation
m = MvnDist('-ndimensions',10,'-prior',MvnInvWishartDist('-ndimensions',10));
S = sample(m,100);
mPoint = fit(m,DataTable(S));

%% Bayesian Estimation
m = MvnConjDist('-ndimensions',10); % defaults to using MvnInvWishartPrior with its default settings             
mBayes = fit(m,DataTable(S));   