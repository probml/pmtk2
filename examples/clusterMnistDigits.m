%% Cluster MNIST Digits and Visualize the Cluster Centers
%% Setup data
setSeed(1);
classes   = 5:7;       % Confine task to digits 5:7 (must be a subset of 0:9)
nexamples = 3000;      % max 60000 
binary = true;
X = setupMnist('-binary',binary,'-ntrain',nexamples,'-ntest',0,'-keepSparse',false,'-classes',classes);    
%% Create the Model
model = MixtureModel('-nmixtures',numel(classes),'-template',FactoredDist(BernoulliDist(),'-ndistributions',size(X,2))); % one dist per feature
model = fit(model,DataTable(X));
%% Visualize fitted model
for i=1:numel(classes)
    figure;
    mu = pmf(model.mixtureComps{i}.params.distributions);
    imagesc(reshape(mu(:,2),28,28));
end
placeFigures('Square',true)


