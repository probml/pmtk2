function imputationDemo()
%% Imputation on random data using specified model

d = 10;
helper(MvnDist(randn(1,d),randpd(d)), d, false);


end


function helper(model, d, discrete)
  
pcMissingTrain = 0;
pcMissingTest = 0.3;
Ntrain = 1000;
Ntest = 5;
setSeed(0);

% Random missing pattern
missingTrain = rand(Ntrain,d) < pcMissingTrain;
missingTest = rand(Ntest,d) < pcMissingTest;




Xtrain = sample(model, Ntrain);
Xtest = sample(model, Ntest);


XtrainMiss = Xtrain;
XtrainMiss(missingTrain) = NaN;
XtestMiss = Xtest;
XtestMiss(missingTest) = NaN;

model = fit(model, '-data', DataTable(XtrainMiss));

XimputeTrain = computeFunPost(model,Query('missingSingles'),DataTable(XtrainMiss),'mode','-filler','visibleData');
[XimputeTest,Vtest] =  computeFunPost(model,Query('missingSingles'),DataTable(XtestMiss),{'mode','var'},'-filler',{'visibleData',0});

if discrete
  errTrain = sum(sum(XimputeTrain ~= Xtrain));
  errTest = sum(sum(XimputeTest ~= Xtest));
else
  errTrain = sum(sum((XimputeTrain - Xtrain).^2))/Ntrain;
  errTest = sum(sum((XimputeTest - Xtest).^2))/Ntest;
end

ttl = sprintf('test err %3.2f', errTest);

if discrete
  % V = entropy
  conf = 1./Vtest;
  conf(isinf(conf))=0;
  mm = max(conf(:));
  hintonScale({Xtest}, {'-map', 'jet', '-title', ttl}, ...
  {Xtest, (1-missingTest)*mm}, { '-title', 'observed'}, ...
  {XimputeTest, conf}, {'-title', 'imputed mode'}, ...
  {Xtest, (missingTest)*mm}, {'-title', 'hidden truth'});
else
  % V = variance
  conf = (1./Vtest);
  conf(isinf(conf))=0;
  mm = max(conf(:));
  hintonScale({Xtest}, {'-map', 'jet', '-title',ttl}, ...
  {Xtest, (1-missingTest)*mm}, { '-title', 'observed'}, ...
  {XimputeTest, conf}, {'-title', 'imputed mean'}, ...
  {Xtest, (missingTest)*mm}, {'-title', 'hidden truth'});
end


end
