%%  A Simple Test of the HmmDist Class


setSeed(0);
nHiddenStates = 4;
nObsStates    = 6; 
nsamples = 20; lens = [13*ones(10,1);30*ones(10,1)]; 
%% Discrete Observations
fprintf('Discrete Observations\n');
obsModel  = copy(DiscreteDist,nHiddenStates,'-nstates',nObsStates);        % remaining args get passed to constructor
srcModel  = Hmm(obsModel);  
[observed,hidden] = sample(srcModel,nsamples,lens);
model = Hmm('-emissionTemplate',DiscreteDist('-nstates',nObsStates),'-nstates',nHiddenStates); % alternative way to construct the object
model = fit(model,'-data',observed);
[postSample , viterbi] = computeFunPost(model , '-data' , observed(1) , '-funcs' , {'sample','mode'}) %#ok
maxmarg = maxidx(inferLatent(model , '-query' , Query('singles') , '-data' , observed(1)))            %#ok
%% MVN Observations
fprintf('Mvn Observations\n');
obsModel =    copy(MvnDist,nHiddenStates,'-ndimensions',10);
srcModel = Hmm(obsModel);
[observed,trueHidden] = sample(srcModel,nsamples,lens);
model = Hmm('-emissionTemplate',MvnDist('-ndimensions',10),'-nstates',nHiddenStates);
model = fit(model,'-data',observed);
[postSample,viterbi] = computeFunPost(model,'-data',observed(1),'-funcs',{'sample','mode'}) %#ok
maxmarg = maxidx(inferLatent(model,'-query',Query('singles'),'-data',observed(1))) %#ok
%% MixMvn Observations
fprintf('MixMvn Observations\n');
obsModel = copy(MixMvn,nHiddenStates,'-nmixtures',2,'-ndimensions',12);
srcModel = Hmm(obsModel);
[observed,trueHidden] = sample(srcModel,nsamples,lens);
model = Hmm('-emissionTemplate',MixMvn('-nmixtures',2,'-ndimensions',12),'-nstates',nHiddenStates);
model = fit(model,'-data',observed);
[postSample,viterbi] = computeFunPost(model,'-data',observed(1),'-funcs',{'sample','mode'}) %#ok
maxmarg = maxidx(inferLatent(model,'-query',Query('singles'),'-data',observed(1))) %#ok

