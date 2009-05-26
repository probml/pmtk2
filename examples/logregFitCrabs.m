%% Logistic Regression on binary Crabs Data
% Here we fit (kernelized) Logistic Regression to the crabs data set using various
% approximations and compare the results. 
%#testPMTK
%% Setup
[Xtrain, ytrain, Xtest, ytest] = makeCrabs; % y in {1,2}
Dtrain = DataTableXY(Xtrain, ytrain);
Dtest = DataTableXY(Xtest, ytest);
sigma2 = 32/5;  lambda = 1e-3;
T = ChainTransformer({StandardizeTransformer(false), KernelTransformer('rbf', sigma2)});
%% MLE
mMLE = LogReg('-nclasses',2, '-transformer', T);
mMLE = fit(mMLE, Dtrain);
[ymle,pY] = inferOutput(mMLE,DataTable(Xtest));
%% MAP
mMAP = LogReg('-prior','L2','-nclasses',2, '-transformer', T,'-lambda',lambda);
mMAP = fit(mMAP, Dtrain);
[ymap,pmap]   = inferOutput(mMAP,DataTable(Xtest));

%% Bayesian (Laplace / Integral)
mLap = LogRegLaplace('-transformer',T,'-lambda',lambda);
mLap = fit(mLap, Dtrain);
ylap = inferOutput(mLap,DataTable(Xtest));
%%
nerrsMLE = sum(ymle ~= ytest)
nerrsMAP = sum(ymap ~= ytest)  
nerrsLap = sum(ylap ~= ytest) 

%{
nr = 2; nc = 2;
figure;
subplot(nr,nc,1); stem(ytest);title('test')
subplot(nr,nc,2); stem(ymap);title('map')
subplot(nr,nc,3); stem(ymap2);title('map2')
subplot(nr,nc,4); stem(ymap3);title('map3')
%}

