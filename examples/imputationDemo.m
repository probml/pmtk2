function imputationDemo()
%% Imputation on random data using specified model
setSeed(0);
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
Q = Query('missingSingles');
Dtrain = DataTable(XtrainMiss);
Dtest  = DataTable(XtestMiss);

XimputeTrain = computeFunPost(model,Q,Dtrain,'mode');
[XimputeTest,Vtest] =  computeFunPost(model,Q,Dtest,{'mode','var'});
Vtest = sqrt(Vtest);



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
  {XimputeTest, conf}, {'-title', 'imputed mode'}, ...
  {Xtest, (missingTest)*mm}, {'-title', 'hidden truth'});
end


end
