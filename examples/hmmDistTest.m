%%  A Simple Test of the HmmDist Class

%% Discrete Observations
setSeed(0);
trueObsModel = {DiscreteDist('-T',ones(6,1)./6       ,'-support',1:6)
    DiscreteDist('-T',[ones(5,1)./10;0.5],'-support',1:6)};

trueTransDist = FactoredDist(DiscreteDist('-T',[0.8,0.2;0.3,0.70]','-support',1:2),'-ndistributions',2);
trueStartDist = DiscreteDist('-T',[0.5,0.5]','-support',1:2);



trueModel = Hmm('-startDist'      , trueStartDist,...
                '-transDist'      , trueTransDist,...
                '-emissionDists'  ,trueObsModel,...
                '-nstates'        ,2           );
            
            
            

nsamples = 20; lens = [repmat(13,nsamples/2,1);repmat(30,nsamples/2,1)];
[observed,hidden] = sample(trueModel,nsamples,lens);


model = Hmm('-emissionTemplate',DiscreteDist('-support',1:6),'-nstates',2);
model = fit(model,'-data',observed);

% 
% 
% model = condition(model,'Y',observed{1}');
% postSample = mode(samplePost(model,1000),2)'
% viterbi = mode(model)
% maxmarg = maxidx(marginal(model,':'))
% 
% %% MVN Observations
% trueObsModel = {MvnDist(zeros(1,10),randpd(10));MvnDist(ones(1,10),randpd(10))};
% trueTransDist = DiscreteDist('-T',[0.8,0.2;0.1,0.90]','-support',1:2);
% trueStartDist = DiscreteDist('-T',[0.5;0.5],'-support',1:2);
% trueModel = HmmDist('startDist'     ,trueStartDist,...
%     'transitionDist',trueTransDist,...
%     'emissionDist'  ,trueObsModel);
% nsamples = 50; length = 5;
% [observed,trueHidden] = sample(trueModel,nsamples,length);
% model = HmmDist('emissionDist',MvnDist(),'nstates',3);
% model = fit(model,'data',observed);
% %% MvnMixDist Observations
% 
% nstates = 5; d = 2; nmixcomps = 2;
% emissionDist = cell(5,1);
% for i=1:nstates
%     %emissionDist{i} = mkRndParams(MvnMixDist('nrestarts',5,'verbose',false),d,nmixcomps);
%     emissionDist{i} = mkRndParams(MixMvn(nmixcomps,d));
% end
% pi = DiscreteDist('-T',normalize(ones(nstates,1)));
% A = DiscreteDist('-T',normalize(rand(nstates),1));
% trueModel = HmmDist('startDist',pi,'transitionDist',A,'emissionDist',emissionDist,'nstates',nstates);
% [observed,hidden] = sample(trueModel,1,500);
% %model = HmmDist('emissionDist',MvnMixDist('nmixtures',nmixcomps,'verbose',false,'nrestarts',1),'nstates',nstates);
% model = HmmDist('emissionDist',MixMvn(nmixcomps, d),'nstates',nstates);
% model = fit(model,'data',observed,'maxIter',20);
% %% DiscreteMixDist Observations
% 
% nstates = 5;  nmixcomps = 2; d = 3;
% emissionDist = cell(5,1);
% for i=1:nstates
%     emissionDist{i} = mkRndParams(DiscreteMixDist('nmixtures',nmixcomps),d,nmixcomps);
% end
% pi = DiscreteDist('-T',normalize(rand(nstates,1)));
% A = DiscreteDist('-T',normalize(rand(nstates),1));
% trueModel = HmmDist('startDist',pi,'transitionDist',A,'emissionDist',emissionDist,'nstates',nstates);
% [observed,hidden] = sample(trueModel,1,500);
% model = HmmDist('emissionDist',DiscreteMixDist('nmixtures',nmixcomps,'verbose',false),'nstates',nstates);
% model = fit(model,'data',observed,'maxIter',20);