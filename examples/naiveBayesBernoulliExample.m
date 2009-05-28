%% Classify Mnist Digits Using a Naive Bayes Classifier

%% Setup Data
Ntrain = 5000;  Ntest  = 1000; nclasses = 10; ndimensions = 28*28;
[Xtrain,ytrain,Xtest,ytest] = setupMnist('-binary',true,'-keepSparse',false,'-ntrain',Ntrain,'-ntest',Ntest);
%% Class Conditionals
% We use a product of BernoulliDists, one per dimension, for each of the 10
% class conditional densities. 
classConditionals = copy(FactoredDist(BernoulliDist('-ndistributions',ndimensions)),nclasses);
classPrior = DiscreteDist('-support',0:9);
%% Create Classifier
classifier = GenClassifier(classConditionals,classPrior);
%% Fit Classifier
classifier = fit(classifier,DataTableXY(Xtrain,ytrain));
%% Infer Output Labels
yHat = inferOutput(classifier,DataTable(Xtest));
%% Assess Performance
err = mean(yHat ~= ytest);
fprintf('Error rate = %g\n',err);

